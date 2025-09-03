#!/usr/bin/env python3
"""Download module for J-PlatPat data."""

import os
import time
import logging
from pathlib import Path
from typing import List, Optional, Dict
from datetime import datetime
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException
from config import Config
from utils_path import normalize_path, get_download_directories, ensure_directory

logger = logging.getLogger(__name__)


class JplatpatDownloader:
    """Handle downloading of J-PlatPat data."""
    
    def __init__(self, driver: webdriver.Chrome):
        """Initialize downloader with authenticated driver."""
        self.driver = driver
        self.download_stats = {}
        self.last_click_timestamp = None
        
    def navigate_to_download_page(self) -> bool:
        """Navigate to the download page and handle agreement."""
        try:
            current_url = self.driver.current_url
            logger.info(f"Current URL: {current_url}")
            
            # Check if already on download page (c1100)
            if 'c1100' in current_url:
                if self.verify_download_page():
                    logger.info("Already on download page")
                    return True
            
            # If on c1200, click agreement button
            if 'c1200' in current_url:
                try:
                    wait = WebDriverWait(self.driver, 10)
                    agree_button = wait.until(
                        EC.element_to_be_clickable((By.ID, 'btnAgree'))
                    )
                    agree_button.click()
                    logger.info("Clicked agreement button (btnAgree) on c1200")
                    time.sleep(3)
                    current_url = self.driver.current_url
                except (TimeoutException, NoSuchElementException):
                    logger.error("Could not find agreement button (btnAgree) on c1200")
                    return False
            
            # If on c1101, click OK button
            if 'c1101' in current_url:
                try:
                    wait = WebDriverWait(self.driver, 10)
                    ok_button = wait.until(
                        EC.element_to_be_clickable((By.ID, 'btnOk'))
                    )
                    ok_button.click()
                    logger.info("Clicked OK button (btnOk) on c1101")
                    time.sleep(3)
                    current_url = self.driver.current_url
                except (TimeoutException, NoSuchElementException):
                    logger.error("Could not find OK button (btnOk) on c1101")
                    return False
            
            # If neither, try to navigate to login URL first
            if 'c1100' not in current_url and 'c1200' not in current_url and 'c1101' not in current_url:
                logger.info("Not on expected page, navigating to login URL")
                self.driver.get(Config.LOGIN_URL)
                time.sleep(3)
                return self.navigate_to_download_page()  # Recursive call
            
            # Verify we're on the download page
            if self.verify_download_page():
                logger.info("Successfully navigated to download page")
                return True
            else:
                logger.error("Could not verify download page")
                return False
            
        except Exception as e:
            logger.error(f"Error navigating to download page: {str(e)}")
            return False
    
    def verify_download_page(self) -> bool:
        """Verify that we're on the download page."""
        try:
            current_url = self.driver.current_url
            logger.info(f"Verifying download page at URL: {current_url}")
            
            # Look for target codes (4-letter alphabets) that indicate we're on the right page
            target_codes = ['JPWAT', 'JPWAC', 'JPWDI', 'JPWMG', 'JPWMP', 'JPWRT', 'JPWT', 'JPWSA']
            
            for code in target_codes:
                try:
                    elements = self.driver.find_elements(By.XPATH, f"//*[contains(text(), '{code}')]")
                    if elements:
                        logger.info(f"Found {code} on page - we're on the download page")
                        return True
                except:
                    continue
            
            # Also check for lblDataName elements which should be present
            try:
                elements = self.driver.find_elements(By.ID, 'lblDataName')
                if elements:
                    logger.info(f"Found {len(elements)} lblDataName elements")
                    return True
            except:
                pass
            
            # Log page content for debugging if nothing found
            try:
                page_text = self.driver.find_element(By.TAG_NAME, 'body').text[:500]
                logger.warning(f"Could not verify download page. Page content: {page_text}")
            except:
                pass
            
            return False
            
        except Exception as e:
            logger.error(f"Error verifying download page: {str(e)}")
            return False
    
    def select_weekly_data(self) -> bool:
        """Select weekly data option."""
        try:
            # Look for weekly data option
            weekly_selectors = [
                (By.XPATH, '//input[@value="weekly"]'),
                (By.XPATH, '//input[@value="Weekly"]'),
                (By.XPATH, '//label[contains(text(), "週次")]'),
                (By.XPATH, '//label[contains(text(), "Weekly")]'),
                (By.ID, 'weekly_data'),
                (By.NAME, 'data_type'),
            ]
            
            for selector_type, selector_value in weekly_selectors:
                try:
                    element = self.driver.find_element(selector_type, selector_value)
                    if element.get_attribute('type') == 'radio' or element.get_attribute('type') == 'checkbox':
                        if not element.is_selected():
                            element.click()
                    else:
                        element.click()
                    logger.info("Selected weekly data option")
                    time.sleep(2)
                    return True
                except NoSuchElementException:
                    continue
            
            logger.warning("Could not find weekly data option, proceeding anyway")
            return True
            
        except Exception as e:
            logger.error(f"Error selecting weekly data: {str(e)}")
            return False
    
    def select_target_data(self, target: str) -> bool:
        """Select specific target data for download - J-PlatPat specific implementation."""
        try:
            description = Config.TARGET_DESCRIPTIONS.get(target, target)
            logger.info(f"Selecting {target}: {description}")
            
            # Step 1: Find and click the lblDataName element using position-based approach
            wait = WebDriverWait(self.driver, 10)
            data_name_element = None
            
            # Map targets to their expected positions (0-indexed) on the J-PlatPat page
            target_positions = {
                'JPWAC': 0,  # 申請人登録マスタ
                'JPWAT': 1,  # 出願マスタ（商標）
                'JPWDI': 2,  # 商標見本ファイル
                'JPWMG': 3,  # マドプロ原簿マスタ
                'JPWMP': 4,  # マドプロ出願マスタ
                'JPWRT': 5,  # 登録マスタ(商標)
                'JPWT': 6,   # 商標基本マスタ
                'JPWSA': 7   # 共有DB(審判)
            }
            
            # Find all lblDataName elements
            all_lblDataName = self.driver.find_elements(By.ID, 'lblDataName')
            logger.info(f"Found {len(all_lblDataName)} elements with id='lblDataName'")
            
            # Try text matching first (works on Windows with proper Japanese display)
            try:
                # Try exact text match
                xpath = f"//a[@id='lblDataName' and text()='{description}']"
                data_name_element = self.driver.find_element(By.XPATH, xpath)
                logger.info(f"Found lblDataName for {target} with EXACT text match: {description}")
            except NoSuchElementException:
                # Try contains match
                try:
                    xpath = f"//a[@id='lblDataName' and contains(text(), '{target}') and contains(text(), 'Weekly_Update')]"
                    data_name_element = self.driver.find_element(By.XPATH, xpath)
                    logger.info(f"Found lblDataName for {target} with partial match")
                except NoSuchElementException:
                    pass
            
            # If text matching fails, try position-based as fallback
            if not data_name_element and target in target_positions:
                position = target_positions[target]
                if position < len(all_lblDataName):
                    data_name_element = all_lblDataName[position]
                    logger.info(f"Selected {target} at position {position} (position-based fallback)")
                else:
                    logger.warning(f"Position {position} for {target} is out of range")
            
            # Last resort: try to find by checking element text
            if not data_name_element:
                try:
                    # Try exact text match
                    xpath = f"//a[@id='lblDataName' and text()='{description}']"
                    data_name_element = self.driver.find_element(By.XPATH, xpath)
                    logger.info(f"Found lblDataName for {target} with EXACT text match: {description}")
                except NoSuchElementException:
                    # Log all available options for debugging
                    for idx, element in enumerate(all_lblDataName):
                        element_text = element.text.strip() if element.text else "[No text]"
                        logger.info(f"  Option {idx}: {element_text}")
                    
                    # Try to find by checking parent HTML for target code
                    for idx, element in enumerate(all_lblDataName):
                        try:
                            parent = element.find_element(By.XPATH, '..')
                            parent_html = parent.get_attribute('outerHTML')
                            if target in parent_html:
                                data_name_element = element
                                logger.info(f"Found {target} at index {idx} by checking parent HTML")
                                break
                        except:
                            pass
            
            if not data_name_element:
                logger.error(f"Could not find lblDataName for {target}")
                # Take screenshot for debugging
                try:
                    screenshot_path = Config.LOG_DIR / f"error_{target}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
                    self.driver.save_screenshot(str(screenshot_path))
                    logger.info(f"Screenshot saved to {screenshot_path}")
                except:
                    pass
                return False
            
            # Click the lblDataName element
            data_name_element.click()
            logger.info(f"Clicked lblDataName for {target}")
            time.sleep(3)  # Wait longer for selection to register
            
            # Step 2: Find the btnToggle button that appears after selecting a target
            # Note: There might be multiple btnToggle buttons, we need the one for our selected target
            try:
                # First, check if the selection was successful by looking for active/selected state
                # Try to find the btnToggle that's now visible/active
                toggle_buttons = self.driver.find_elements(By.ID, 'btnToggle')
                logger.info(f"Found {len(toggle_buttons)} btnToggle buttons")
                
                # Click the first visible/enabled btnToggle
                toggle_button = None
                for btn in toggle_buttons:
                    if btn.is_displayed() and btn.is_enabled():
                        toggle_button = btn
                        break
                
                if not toggle_button:
                    # Fallback to wait for clickable
                    toggle_button = wait.until(
                        EC.element_to_be_clickable((By.ID, 'btnToggle'))
                    )
                
                toggle_button.click()
                logger.info(f"Clicked btnToggle to expand {target} options")
                time.sleep(3)  # Wait longer for expansion
            except (TimeoutException, NoSuchElementException):
                logger.error(f"Could not find btnToggle for {target}")
                return False
            
            # Step 3: Find and click the download link with class bulk_table_download_link
            # IMPORTANT: After btnToggle, multiple download links may appear
            # We need to select the correct one (should be in the expanded section)
            try:
                # Wait for the expanded section to appear
                time.sleep(1)
                
                # Find all download links
                download_links = self.driver.find_elements(By.CLASS_NAME, 'bulk_table_download_link')
                logger.info(f"Found {len(download_links)} download links")
                
                # Log all available download links for debugging
                all_links_info = []
                for idx, link in enumerate(download_links):
                    href = link.get_attribute('href') or ""
                    text = link.text.strip() if link.text else "No text"
                    logger.info(f"  Link {idx}: {text} -> {href}")
                    all_links_info.append((idx, text, href))
                
                # Try different strategies to find the correct link
                clicked = False
                
                # Strategy 1: Check if the href URL contains our target code
                # Skip JPCS links when looking for other targets
                for idx, text, href in all_links_info:
                    # Skip JPCS links unless we're specifically looking for JPCS
                    if target != 'JPCS' and 'JPCS' in href:
                        continue
                    
                    if f"/{target}/" in href or f"{target}_" in href:
                        logger.info(f"Found matching download link for {target} (by URL): {href}")
                        link = download_links[idx]
                        self.driver.execute_script("arguments[0].click();", link)
                        clicked = True
                        break
                
                # Strategy 2: If no URL match, try the first visible link after btnToggle
                # (Usually the correct link is the first one after expansion)
                if not clicked and download_links:
                    logger.info(f"No URL match found for {target}, trying first visible link")
                    for link in download_links:
                        if link.is_displayed():
                            href = link.get_attribute('href') or ""
                            logger.info(f"Clicking first visible link: {href}")
                            self.driver.execute_script("arguments[0].click();", link)
                            clicked = True
                            break
                
                if clicked:
                    logger.info(f"Clicked download link for {target} - download should start")
                    
                    # Record the click timestamp for filtering old files
                    click_timestamp = time.time()
                    
                    # Wait a moment for download to initiate
                    time.sleep(3)
                    
                    # Check if a new window/tab opened
                    if len(self.driver.window_handles) > 1:
                        # Switch to the new window
                        self.driver.switch_to.window(self.driver.window_handles[-1])
                        logger.info("Switched to new download window")
                        time.sleep(2)
                        # Switch back to main window
                        self.driver.switch_to.window(self.driver.window_handles[0])
                    
                    # Store the click timestamp in the instance for later use
                    self.last_click_timestamp = click_timestamp
                    
                    # Download initiated successfully - let download_target handle the wait
                    logger.info(f"Download initiated for {target}")
                    return True
                
                # If no link clicked, log error
                logger.error(f"Could not find or click download link for {target}")
                return False
                
            except (TimeoutException, NoSuchElementException):
                logger.error(f"Could not find download link for {target}")
                return False
            
        except Exception as e:
            logger.error(f"Error selecting {target}: {str(e)}")
            return False
    
    def select_date_range(self, date: Optional[str] = None) -> bool:
        """Select date range for download."""
        try:
            if date:
                # Parse date string (format: YYYYMMDD)
                year = date[:4]
                month = date[4:6]
                day = date[6:8]
                
                # Try to find date input fields
                date_selectors = [
                    (By.ID, 'date'),
                    (By.NAME, 'date'),
                    (By.ID, 'target_date'),
                    (By.NAME, 'target_date'),
                    (By.CSS_SELECTOR, 'input[type="date"]'),
                ]
                
                for selector_type, selector_value in date_selectors:
                    try:
                        date_input = self.driver.find_element(selector_type, selector_value)
                        date_input.clear()
                        # Format date for HTML5 date input
                        formatted_date = f"{year}-{month}-{day}"
                        date_input.send_keys(formatted_date)
                        logger.info(f"Set date to {formatted_date}")
                        return True
                    except NoSuchElementException:
                        continue
                
                # Try dropdowns for year/month/day
                try:
                    year_select = self.driver.find_element(By.ID, 'year')
                    month_select = self.driver.find_element(By.ID, 'month')
                    day_select = self.driver.find_element(By.ID, 'day')
                    
                    from selenium.webdriver.support.ui import Select
                    Select(year_select).select_by_value(year)
                    Select(month_select).select_by_value(month)
                    Select(day_select).select_by_value(day)
                    logger.info(f"Set date to {year}/{month}/{day}")
                    return True
                except NoSuchElementException:
                    pass
            else:
                # Select latest/current option
                latest_selectors = [
                    (By.XPATH, '//input[@value="latest"]'),
                    (By.XPATH, '//input[@value="current"]'),
                    (By.XPATH, '//label[contains(text(), "最新")]'),
                    (By.XPATH, '//label[contains(text(), "Latest")]'),
                ]
                
                for selector_type, selector_value in latest_selectors:
                    try:
                        element = self.driver.find_element(selector_type, selector_value)
                        if not element.is_selected():
                            element.click()
                        logger.info("Selected latest data")
                        return True
                    except NoSuchElementException:
                        continue
            
            logger.info("No date selection found, proceeding with default")
            return True
            
        except Exception as e:
            logger.error(f"Error selecting date: {str(e)}")
            return False
    
    def start_download(self) -> bool:
        """Start the download process."""
        try:
            # Find and click download button
            download_button_selectors = [
                (By.ID, 'download'),
                (By.ID, 'submit'),
                (By.NAME, 'download'),
                (By.CSS_SELECTOR, 'button[type="submit"]'),
                (By.XPATH, '//button[contains(text(), "ダウンロード")]'),
                (By.XPATH, '//input[@value="ダウンロード"]'),
                (By.XPATH, '//button[contains(text(), "Download")]'),
            ]
            
            for selector_type, selector_value in download_button_selectors:
                try:
                    button = self.driver.find_element(selector_type, selector_value)
                    button.click()
                    logger.info("Download started")
                    return True
                except NoSuchElementException:
                    continue
            
            logger.error("Could not find download button")
            return False
            
        except Exception as e:
            logger.error(f"Error starting download: {str(e)}")
            return False
    
    def wait_for_download(self, target: str, timeout: int = 300, click_timestamp: float = None) -> Optional[Path]:
        """Wait for download to complete and return file path.
        
        Args:
            target: Target code (e.g., 'JPWAT')
            timeout: Maximum wait time in seconds
            click_timestamp: Timestamp when download was initiated (to filter old files)
            
        Returns:
            Path to downloaded file or None if timeout
        """
        try:
            pattern = Config.FILE_PATTERNS.get(target, f"JP*.{{zip,tar.gz}}")
            
            # Get all possible download directories with proper path normalization
            download_dirs = get_download_directories()
            
            logger.info(f"Waiting for {pattern}")
            logger.info(f"Checking directories: {download_dirs}")
            
            # If no click timestamp provided, use current time minus a small buffer
            if click_timestamp is None:
                click_timestamp = time.time() - 5
            
            start_time = time.time()
            while time.time() - start_time < timeout:
                # Check for downloaded files in all directories
                files = []
                for check_dir in download_dirs:
                    # Try the target-specific pattern first
                    files.extend(list(check_dir.glob(pattern)))
                    # Also check for general JP* patterns
                    files.extend(list(check_dir.glob("JP*.tar.gz")))
                    files.extend(list(check_dir.glob("JP*.zip")))
                # Remove duplicates
                files = list(set(files))
                
                # Log any files found
                if files:
                    logger.debug(f"Found files: {[f.name for f in files]}")
                
                # Filter out partial downloads and old files
                complete_files = []
                for file in files:
                    if not str(file).endswith('.crdownload') and not str(file).endswith('.tmp'):
                        try:
                            stat = file.stat()
                            # Only consider files created after the click
                            if stat.st_mtime >= click_timestamp and stat.st_size > 0:
                                complete_files.append(file)
                                logger.info(f"Found recently downloaded file: {file.name} (size: {stat.st_size} bytes)")
                        except (OSError, FileNotFoundError):
                            # File might have been deleted or moved
                            continue
                
                if complete_files:
                    # Get the most recent file
                    latest_file = max(complete_files, key=lambda f: f.stat().st_mtime)
                    
                    # Wait a bit to ensure download is complete
                    time.sleep(2)
                    
                    # Check file size is stable
                    size1 = latest_file.stat().st_size
                    time.sleep(2)
                    size2 = latest_file.stat().st_size
                    
                    if size1 == size2 and size1 > 0:
                        logger.info(f"Download complete: {latest_file}")
                        return latest_file
                
                # Check for download errors on page
                error_selectors = [
                    (By.CLASS_NAME, 'error'),
                    (By.CLASS_NAME, 'alert-danger'),
                    (By.XPATH, '//*[contains(text(), "エラー")]'),
                ]
                
                for selector_type, selector_value in error_selectors:
                    try:
                        error = self.driver.find_element(selector_type, selector_value)
                        if error.is_displayed():
                            logger.error(f"Download error: {error.text}")
                            return None
                    except NoSuchElementException:
                        pass
                
                time.sleep(5)
            
            logger.error(f"Download timeout for {target}")
            return None
            
        except Exception as e:
            logger.error(f"Error waiting for download: {str(e)}")
            return None
    
    def download_target(self, target: str, date: Optional[str] = None) -> Dict:
        """Download a specific target."""
        result = {
            'target': target,
            'date': date or 'latest',
            'status': 'failed',
            'file': None,
            'error': None
        }
        
        try:
            logger.info(f"Starting download for {target}")
            
            # Navigate to download page
            if not self.navigate_to_download_page():
                result['error'] = 'Failed to navigate to download page'
                return result
            
            # Select weekly data
            if not self.select_weekly_data():
                result['error'] = 'Failed to select weekly data'
                return result
            
            # Select target - this will also start the download
            if not self.select_target_data(target):
                result['error'] = f'Failed to select {target}'
                return result
            
            # Note: Clicking bulk_table_download_link already starts the download
            # No need to call start_download() separately
            
            # Wait for download to complete
            # Use the timestamp from when the download was initiated
            click_timestamp = getattr(self, 'last_click_timestamp', None)
            file_path = self.wait_for_download(target, timeout=300, click_timestamp=click_timestamp)
            if file_path:
                result['status'] = 'success'
                result['file'] = str(file_path)
                logger.info(f"Successfully downloaded {target} to {file_path}")
            else:
                result['error'] = 'Download did not complete'
            
            # Return to login page for next download (will redirect to download page)
            time.sleep(3)
            self.driver.get(Config.LOGIN_URL)
            time.sleep(2)
            
        except Exception as e:
            logger.error(f"Error downloading {target}: {str(e)}")
            result['error'] = str(e)
        
        return result
    
    def download_all(self, targets: List[str], date: Optional[str] = None) -> Dict:
        """Download all specified targets."""
        results = {
            'total': len(targets),
            'success': 0,
            'failed': 0,
            'targets': {}
        }
        
        for target in targets:
            logger.info(f"Processing {target} ({targets.index(target) + 1}/{len(targets)})")
            result = self.download_target(target, date)
            results['targets'][target] = result
            
            if result['status'] == 'success':
                results['success'] += 1
            else:
                results['failed'] += 1
            
            # Wait between downloads
            if targets.index(target) < len(targets) - 1:
                time.sleep(5)
        
        logger.info(f"Download complete: {results['success']} success, {results['failed']} failed")
        return results