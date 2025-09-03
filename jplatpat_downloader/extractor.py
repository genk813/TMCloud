#!/usr/bin/env python3
"""Extraction module for downloaded files."""

import os
import re
import zipfile
import tarfile
import shutil
import logging
from pathlib import Path
from typing import Optional, List, Dict
from config import Config
from utils_path import normalize_path, ensure_directory

logger = logging.getLogger(__name__)


class FileExtractor:
    """Handle extraction of downloaded archive files."""
    
    @staticmethod
    def extract_date_from_filename(filename: str) -> Optional[str]:
        """Extract date from filename (e.g., JPWDI_20250827.tar.gz -> 20250827)."""
        # Pattern for JPXXX_YYYYMMDD.tar.gz or JPXXX_YYYYMMDD.zip
        pattern = r'JP[A-Z]+_(\d{8})\.'
        match = re.search(pattern, filename)
        if match:
            return match.group(1)
        
        # Alternative pattern for JPXXX YYYYMMDD (with space)
        pattern2 = r'JP[A-Z]+\s+(\d{8})'
        match = re.search(pattern2, filename)
        if match:
            return match.group(1)
        
        # Check for date in path (e.g., /20250827/)
        pattern3 = r'/(\d{8})/'
        match = re.search(pattern3, filename)
        if match:
            return match.group(1)
        
        return None
    
    @staticmethod
    def get_archive_type(file_path: Path) -> Optional[str]:
        """Determine the type of archive file."""
        if file_path.suffix.lower() == '.zip':
            return 'zip'
        elif file_path.suffix.lower() in ['.tar', '.gz', '.bz2', '.xz']:
            return 'tar'
        elif str(file_path).endswith('.tar.gz'):
            return 'tar'
        else:
            return None
    
    @staticmethod
    def extract_zip(file_path: Path, extract_to: Path) -> bool:
        """Extract ZIP file."""
        try:
            logger.info(f"Extracting ZIP file: {file_path}")
            
            with zipfile.ZipFile(file_path, 'r') as zip_ref:
                # Get list of files in archive
                file_list = zip_ref.namelist()
                logger.info(f"Archive contains {len(file_list)} files")
                
                # Create extraction directory
                extract_to.mkdir(parents=True, exist_ok=True)
                
                # Extract all files
                zip_ref.extractall(extract_to)
                
                logger.info(f"Successfully extracted to {extract_to}")
                return True
                
        except zipfile.BadZipFile:
            logger.error(f"Invalid ZIP file: {file_path}")
            return False
        except Exception as e:
            logger.error(f"Error extracting ZIP file: {str(e)}")
            return False
    
    @staticmethod
    def extract_tar(file_path: Path, extract_to: Path) -> bool:
        """Extract TAR file (including .tar.gz, .tar.bz2, etc.)."""
        try:
            logger.info(f"Extracting TAR file: {file_path}")
            
            # Determine compression mode
            mode = 'r'
            if str(file_path).endswith('.tar.gz') or str(file_path).endswith('.tgz'):
                mode = 'r:gz'
            elif str(file_path).endswith('.tar.bz2'):
                mode = 'r:bz2'
            elif str(file_path).endswith('.tar.xz'):
                mode = 'r:xz'
            
            with tarfile.open(file_path, mode) as tar_ref:
                # Get list of files in archive
                file_list = tar_ref.getnames()
                logger.info(f"Archive contains {len(file_list)} files")
                
                # Create extraction directory
                extract_to.mkdir(parents=True, exist_ok=True)
                
                # Extract all files
                tar_ref.extractall(extract_to)
                
                logger.info(f"Successfully extracted to {extract_to}")
                return True
                
        except tarfile.TarError as e:
            logger.error(f"Invalid TAR file: {file_path} - {str(e)}")
            return False
        except Exception as e:
            logger.error(f"Error extracting TAR file: {str(e)}")
            return False
    
    @staticmethod
    def copy_to_tsv_dir(extract_dir: Path, date: str) -> bool:
        """Copy extracted files to TSV data directory."""
        try:
            # Get TSV directory for this date
            tsv_dir = Config.get_tsv_dir(date)
            tsv_dir = Path(normalize_path(str(tsv_dir)))
            
            # Create TSV directory if it doesn't exist
            tsv_dir.mkdir(parents=True, exist_ok=True)
            
            logger.info(f"Copying files from {extract_dir} to {tsv_dir}")
            
            # Copy all TSV files, including from subdirectories
            file_count = 0
            
            # First check direct files
            for item in extract_dir.iterdir():
                if item.is_file() and item.suffix == '.tsv':
                    dest = tsv_dir / item.name
                    shutil.copy2(item, dest)
                    file_count += 1
                    logger.debug(f"Copied {item.name} to {dest}")
            
            # Then check subdirectories (common structure for J-PlatPat archives)
            for subdir in extract_dir.iterdir():
                if subdir.is_dir():
                    logger.info(f"Checking subdirectory: {subdir.name}")
                    for item in subdir.iterdir():
                        if item.is_file() and item.suffix == '.tsv':
                            dest = tsv_dir / item.name
                            shutil.copy2(item, dest)
                            file_count += 1
                            logger.debug(f"Copied {item.name} from {subdir.name} to {dest}")
            
            logger.info(f"Copied {file_count} files to TSV directory: {tsv_dir}")
            return True
            
        except Exception as e:
            logger.error(f"Error copying to TSV directory: {str(e)}")
            return False
    
    @staticmethod
    def extract_file(file_path: Path, target: str, date: Optional[str] = None) -> Optional[Path]:
        """Extract a downloaded file to the appropriate directory."""
        try:
            if not file_path.exists():
                logger.error(f"File not found: {file_path}")
                return None
            
            # Extract date from filename if not provided
            if not date or date == 'latest':
                extracted_date = FileExtractor.extract_date_from_filename(str(file_path))
                if extracted_date:
                    date = extracted_date
                    logger.info(f"Extracted date {date} from filename")
                else:
                    # Try to use today's date
                    from datetime import datetime
                    date = datetime.now().strftime('%Y%m%d')
                    logger.info(f"Using current date: {date}")
            
            # Determine extraction directory with proper path normalization
            extract_dir = Config.get_target_dir(target, date)
            # Normalize the path to ensure it's correct for the current environment
            extract_dir = Path(normalize_path(str(extract_dir)))
            
            logger.info(f"Normalized extraction directory: {extract_dir}")
            
            # Check archive type
            archive_type = FileExtractor.get_archive_type(file_path)
            
            if not archive_type:
                logger.warning(f"Unknown archive type: {file_path}")
                # If not an archive, just copy the file
                extract_dir.mkdir(parents=True, exist_ok=True)
                dest_file = extract_dir / file_path.name
                shutil.copy2(file_path, dest_file)
                logger.info(f"Copied file to {dest_file}")
                return extract_dir
            
            # Extract based on type
            success = False
            if archive_type == 'zip':
                success = FileExtractor.extract_zip(file_path, extract_dir)
            elif archive_type == 'tar':
                success = FileExtractor.extract_tar(file_path, extract_dir)
            
            if success:
                logger.info(f"Extraction complete for {target}")
                
                # Copy to TSV directory if date is available
                if date:
                    if FileExtractor.copy_to_tsv_dir(extract_dir, date):
                        logger.info(f"Successfully copied {target} files to TSV directory for date {date}")
                    else:
                        logger.warning(f"Failed to copy {target} files to TSV directory")
                
                return extract_dir
            else:
                logger.error(f"Extraction failed for {target}")
                return None
                
        except Exception as e:
            logger.error(f"Error during extraction: {str(e)}")
            return None
    
    @staticmethod
    def clean_raw_files(file_paths: List[Path], keep_raw: bool = False) -> None:
        """Clean up raw downloaded files."""
        if keep_raw:
            logger.info("Keeping raw files as requested")
            return
        
        try:
            for file_path in file_paths:
                if file_path.exists():
                    file_path.unlink()
                    logger.info(f"Deleted raw file: {file_path}")
        except Exception as e:
            logger.error(f"Error cleaning up files: {str(e)}")
    
    @staticmethod
    def process_downloads(download_results: Dict, keep_raw: bool = False) -> Dict:
        """Process all downloaded files."""
        extraction_results = {
            'total': 0,
            'success': 0,
            'failed': 0,
            'targets': {}
        }
        
        raw_files = []
        
        for target, result in download_results['targets'].items():
            if result['status'] == 'success' and result['file']:
                extraction_results['total'] += 1
                file_path = Path(result['file'])
                raw_files.append(file_path)
                
                # Extract file
                extract_dir = FileExtractor.extract_file(
                    file_path, 
                    target, 
                    result.get('date')
                )
                
                if extract_dir:
                    extraction_results['success'] += 1
                    extraction_results['targets'][target] = {
                        'status': 'success',
                        'extracted_to': str(extract_dir),
                        'raw_file': str(file_path)
                    }
                else:
                    extraction_results['failed'] += 1
                    extraction_results['targets'][target] = {
                        'status': 'failed',
                        'error': 'Extraction failed',
                        'raw_file': str(file_path)
                    }
        
        # Clean up raw files if requested
        if not keep_raw and raw_files:
            FileExtractor.clean_raw_files(raw_files, keep_raw)
        
        logger.info(f"Extraction complete: {extraction_results['success']} success, {extraction_results['failed']} failed")
        return extraction_results
    
    @staticmethod
    def verify_extraction(extract_dir: Path) -> Dict:
        """Verify extracted files."""
        try:
            if not extract_dir.exists():
                return {'exists': False, 'file_count': 0, 'total_size': 0}
            
            files = list(extract_dir.rglob('*'))
            file_count = len([f for f in files if f.is_file()])
            total_size = sum(f.stat().st_size for f in files if f.is_file())
            
            return {
                'exists': True,
                'file_count': file_count,
                'total_size': total_size,
                'size_mb': round(total_size / (1024 * 1024), 2)
            }
            
        except Exception as e:
            logger.error(f"Error verifying extraction: {str(e)}")
            return {'exists': False, 'error': str(e)}