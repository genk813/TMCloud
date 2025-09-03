#!/usr/bin/env python3
"""Authentication module for J-PlatPat."""

import time
import logging
from typing import Optional
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.common.exceptions import TimeoutException, NoSuchElementException
from webdriver_manager.chrome import ChromeDriverManager
from config import Config
from utils_path import normalize_path, ensure_directory

logger = logging.getLogger(__name__)


class JplatpatAuth:
    """Handle authentication for J-PlatPat."""
    
    def __init__(self, headless: bool = True):
        """Initialize authentication handler."""
        self.headless = headless
        self.driver: Optional[webdriver.Chrome] = None
        self.logged_in = False
        
    def setup_driver(self) -> webdriver.Chrome:
        """Setup Chrome driver with appropriate options."""
        options = Options()
        
        if self.headless:
            options.add_argument('--headless')
            options.add_argument('--disable-gpu')
            
        # Common options
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument('--window-size=1920,1080')
        options.add_argument('--disable-blink-features=AutomationControlled')
        
        # Japanese language and encoding settings to prevent garbled text
        options.add_argument('--lang=ja-JP')
        options.add_argument('--accept-language=ja-JP,ja;q=0.9,en;q=0.8')
        
        # Force UTF-8 encoding for proper Japanese display
        options.add_argument('--force-device-scale-factor=1')
        options.add_argument('--disable-features=IsolateOrigins,site-per-process')
        
        # Set environment for Japanese locale
        import os
        os.environ['LANG'] = 'ja_JP.UTF-8'
        os.environ['LC_ALL'] = 'ja_JP.UTF-8'
        
        # Additional options for WSL/Linux environment
        options.add_argument('--disable-extensions')
        options.add_argument('--disable-setuid-sandbox')
        options.add_argument('--remote-debugging-port=9222')
        
        options.add_experimental_option("excludeSwitches", ["enable-automation"])
        options.add_experimental_option('useAutomationExtension', False)
        
        # Set download preferences with proper path normalization
        download_dir = normalize_path(str(Config.DOWNLOAD_DIR))
        
        # Ensure download directory exists
        ensure_directory(download_dir)
        
        logger.info(f"Normalized download directory: {download_dir}")
            
        prefs = {
            'download.default_directory': download_dir,
            'download.prompt_for_download': False,
            'download.directory_upgrade': True,
            'safebrowsing.enabled': False,
            'safebrowsing.disable_download_protection': True,
            'plugins.always_open_pdf_externally': True,
            'profile.default_content_setting_values.automatic_downloads': 1,
            'intl.accept_languages': 'ja-JP,ja,en-US,en',
            'intl.charset_detector': 'Universal',
            'profile.default_content_settings.popups': 0,
            'profile.managed_default_content_settings.javascript': 1
        }
        options.add_experimental_option('prefs', prefs)
        
        # Enable automatic downloads in headless mode
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-web-security')
        options.add_argument('--disable-features=VizDisplayCompositor')
        
        # Automatically download and use ChromeDriver
        try:
            import os
            import platform
            
            # Check if running on Windows or WSL
            if platform.system() == 'Windows' or os.path.exists('C:\\Windows'):
                # Windows environment
                logger.info("Running on Windows, using Chrome")
                # Let ChromeDriverManager find Chrome automatically
                service = Service(ChromeDriverManager().install())
                self.driver = webdriver.Chrome(service=service, options=options)
            else:
                # WSL/Linux environment
                logger.info("Running on WSL/Linux, using Chromium")
                if os.path.exists('/snap/bin/chromium'):
                    options.binary_location = '/snap/bin/chromium'
                    logger.info("Using snap chromium at /snap/bin/chromium")
                elif os.path.exists('/usr/bin/chromium-browser'):
                    options.binary_location = '/usr/bin/chromium-browser'
                    logger.info("Using chromium-browser at /usr/bin/chromium-browser")
                elif os.path.exists('/usr/bin/chromium'):
                    options.binary_location = '/usr/bin/chromium'
                    logger.info("Using chromium at /usr/bin/chromium")
                
                # Use chromium-browser type for webdriver-manager
                service = Service(ChromeDriverManager(chrome_type='chromium').install())
                self.driver = webdriver.Chrome(service=service, options=options)
                
            
            # Enable download in headless mode for all browsers
            if self.headless and self.driver:
                params = {
                    'behavior': 'allow',
                    'downloadPath': download_dir  # Use the normalized download_dir
                }
                self.driver.execute_cdp_cmd('Page.setDownloadBehavior', params)
                logger.info(f"Enabled headless download to: {download_dir}")
            
            logger.info("ChromeDriver setup successful")
        except Exception as e:
            logger.error(f"Failed to setup ChromeDriver: {str(e)}")
            raise
        
        self.driver.execute_script("Object.defineProperty(navigator, 'webdriver', {get: () => undefined})")
        
        return self.driver
    
    def login(self, max_retries: int = 3) -> bool:
        """Login to J-PlatPat."""
        for attempt in range(max_retries):
            try:
                logger.info(f"Login attempt {attempt + 1}/{max_retries}")
                
                if not self.driver:
                    self.setup_driver()
                
                # Navigate to login page
                logger.info(f"Navigating to {Config.LOGIN_URL}")
                self.driver.get(Config.LOGIN_URL)
                time.sleep(3)  # Wait for page to fully load
                
                # Find and fill login form
                wait = WebDriverWait(self.driver, Config.TIMEOUT)
                
                # J-PlatPat specific selectors for username field
                username_selectors = [
                    (By.ID, 'C1000_input_userid'),  # J-PlatPat specific ID
                    (By.ID, 'username'),
                    (By.NAME, 'username'),
                    (By.ID, 'user_id'),
                    (By.NAME, 'user_id'),
                    (By.ID, 'login_id'),
                    (By.NAME, 'login_id'),
                    (By.CSS_SELECTOR, 'input[type="text"]'),
                ]
                
                username_field = None
                for selector_type, selector_value in username_selectors:
                    try:
                        username_field = wait.until(
                            EC.presence_of_element_located((selector_type, selector_value))
                        )
                        logger.info(f"Found username field with selector: {selector_type}, {selector_value}")
                        break
                    except TimeoutException:
                        continue
                
                if not username_field:
                    raise Exception("Could not find username field")
                
                username_field.clear()
                username_field.send_keys(Config.JPLATPAT_USERNAME)
                
                # J-PlatPat specific selectors for password field
                password_selectors = [
                    (By.ID, 'C1000_input_password'),  # J-PlatPat specific ID
                    (By.ID, 'password'),
                    (By.NAME, 'password'),
                    (By.ID, 'pass'),
                    (By.NAME, 'pass'),
                    (By.CSS_SELECTOR, 'input[type="password"]'),
                ]
                
                password_field = None
                for selector_type, selector_value in password_selectors:
                    try:
                        password_field = self.driver.find_element(selector_type, selector_value)
                        logger.info(f"Found password field with selector: {selector_type}, {selector_value}")
                        break
                    except NoSuchElementException:
                        continue
                
                if not password_field:
                    raise Exception("Could not find password field")
                
                password_field.clear()
                password_field.send_keys(Config.JPLATPAT_PASSWORD)
                
                # J-PlatPat specific selectors for login button
                login_button_selectors = [
                    (By.ID, 'C1000_ope_btnLogin'),  # J-PlatPat specific ID
                    (By.ID, 'login'),
                    (By.ID, 'submit'),
                    (By.NAME, 'login'),
                    (By.NAME, 'submit'),
                    (By.CSS_SELECTOR, 'button[type="submit"]'),
                    (By.CSS_SELECTOR, 'input[type="submit"]'),
                    (By.XPATH, '//button[contains(text(), "ログイン")]'),
                    (By.XPATH, '//input[@value="ログイン"]'),
                ]
                
                login_button = None
                for selector_type, selector_value in login_button_selectors:
                    try:
                        login_button = self.driver.find_element(selector_type, selector_value)
                        logger.info(f"Found login button with selector: {selector_type}, {selector_value}")
                        break
                    except NoSuchElementException:
                        continue
                
                if not login_button:
                    raise Exception("Could not find login button")
                
                login_button.click()
                
                # Wait for login to complete
                time.sleep(5)
                
                # Check if login was successful
                if self.verify_login():
                    logger.info("Login successful")
                    self.logged_in = True
                    return True
                else:
                    logger.warning("Login verification failed")
                    
            except Exception as e:
                logger.error(f"Login attempt {attempt + 1} failed: {str(e)}")
                if attempt < max_retries - 1:
                    time.sleep(5)
                    
        logger.error("All login attempts failed")
        return False
    
    def verify_login(self) -> bool:
        """Verify if login was successful."""
        try:
            # Check if we're redirected away from login page
            current_url = self.driver.current_url
            if Config.LOGIN_URL not in current_url:
                return True
            
            # Check for error messages
            error_selectors = [
                (By.CLASS_NAME, 'error'),
                (By.CLASS_NAME, 'alert'),
                (By.ID, 'error_message'),
            ]
            
            for selector_type, selector_value in error_selectors:
                try:
                    error_element = self.driver.find_element(selector_type, selector_value)
                    if error_element.is_displayed():
                        logger.error(f"Login error detected: {error_element.text}")
                        return False
                except NoSuchElementException:
                    pass
            
            # Check for logout button or user menu (indicates successful login)
            success_selectors = [
                (By.ID, 'logout'),
                (By.LINK_TEXT, 'ログアウト'),
                (By.CLASS_NAME, 'user-menu'),
                (By.ID, 'user-menu'),
            ]
            
            for selector_type, selector_value in success_selectors:
                try:
                    self.driver.find_element(selector_type, selector_value)
                    return True
                except NoSuchElementException:
                    pass
            
            # If URL changed and no errors, assume success
            return current_url != Config.LOGIN_URL
            
        except Exception as e:
            logger.error(f"Error verifying login: {str(e)}")
            return False
    
    def logout(self):
        """Logout from J-PlatPat."""
        try:
            if self.driver and self.logged_in:
                # Try to find and click logout button
                logout_selectors = [
                    (By.ID, 'logout'),
                    (By.LINK_TEXT, 'ログアウト'),
                    (By.XPATH, '//a[contains(text(), "ログアウト")]'),
                ]
                
                for selector_type, selector_value in logout_selectors:
                    try:
                        logout_button = self.driver.find_element(selector_type, selector_value)
                        logout_button.click()
                        logger.info("Logged out successfully")
                        break
                    except NoSuchElementException:
                        continue
                
                self.logged_in = False
                
        except Exception as e:
            logger.error(f"Error during logout: {str(e)}")
    
    def close(self):
        """Close the browser driver."""
        try:
            if self.driver:
                self.driver.quit()
                self.driver = None
                self.logged_in = False
                logger.info("Browser closed")
        except Exception as e:
            logger.error(f"Error closing browser: {str(e)}")
    
    def __enter__(self):
        """Context manager entry."""
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit."""
        self.close()