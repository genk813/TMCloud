#!/usr/bin/env python3
"""Main script for J-PlatPat automatic downloader."""

import sys
import argparse
import logging
from pathlib import Path
from datetime import datetime
from typing import Optional

from config import Config
from auth import JplatpatAuth
from downloader import JplatpatDownloader
from extractor import FileExtractor
from utils import (
    setup_logging, 
    save_results, 
    print_summary, 
    validate_date,
    check_disk_space,
    clean_old_logs
)

logger = logging.getLogger(__name__)


def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        description='J-PlatPat Automatic Downloader - Download trademark data from J-PlatPat'
    )
    
    parser.add_argument(
        '--date',
        type=str,
        help='Target date for download (format: YYYYMMDD). Default: latest',
        default=None
    )
    
    parser.add_argument(
        '--targets',
        type=str,
        help='Comma-separated list of targets to download. Default: all configured targets',
        default=None
    )
    
    parser.add_argument(
        '--keep-raw',
        action='store_true',
        help='Keep raw downloaded files after extraction',
        default=False
    )
    
    parser.add_argument(
        '--no-headless',
        action='store_true',
        help='Run browser in visible mode (not headless)',
        default=False
    )
    
    parser.add_argument(
        '--log-level',
        type=str,
        choices=['DEBUG', 'INFO', 'WARNING', 'ERROR'],
        help='Set logging level',
        default='INFO'
    )
    
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Test configuration without downloading',
        default=False
    )
    
    return parser.parse_args()


def main():
    """Main execution function."""
    # Parse arguments
    args = parse_arguments()
    
    # Setup logging with debug for troubleshooting
    log_level = 'DEBUG' if args.log_level == 'DEBUG' else args.log_level
    setup_logging(Config.LOG_DIR, log_level)
    logger.info("="*60)
    logger.info("J-PlatPat Automatic Downloader Started")
    logger.info("="*60)
    
    try:
        # Validate configuration
        Config.validate()
        logger.info("Configuration validated successfully")
        
        # Check disk space
        if not check_disk_space(Config.DOWNLOAD_DIR):
            response = input("Low disk space detected. Continue anyway? (y/n): ")
            if response.lower() != 'y':
                logger.info("Aborted due to low disk space")
                return 1
        
        # Clean old logs
        clean_old_logs(Config.LOG_DIR, keep_days=30)
        
        # Validate date if provided
        if args.date and not validate_date(args.date):
            logger.error(f"Invalid date format: {args.date}. Use YYYYMMDD format.")
            return 1
        
        # Determine targets
        if args.targets:
            targets = [t.strip() for t in args.targets.split(',')]
        else:
            targets = Config.DOWNLOAD_TARGETS
        
        # Validate targets
        invalid_targets = [t for t in targets if t not in Config.TARGET_DESCRIPTIONS]
        if invalid_targets:
            logger.error(f"Invalid targets: {invalid_targets}")
            logger.info(f"Valid targets: {list(Config.TARGET_DESCRIPTIONS.keys())}")
            return 1
        
        logger.info(f"Targets to download: {targets}")
        if args.date:
            logger.info(f"Target date: {args.date}")
        else:
            logger.info("Target date: latest")
        
        # Dry run check
        if args.dry_run:
            logger.info("DRY RUN MODE - No actual download will be performed")
            print("\nConfiguration Summary:")
            print(f"  Targets: {', '.join(targets)}")
            print(f"  Date: {args.date or 'latest'}")
            print(f"  Download Dir: {Config.DOWNLOAD_DIR}")
            print(f"  Extract Dir: {Config.EXTRACT_DIR}")
            print(f"  Headless: {not args.no_headless}")
            print(f"  Keep Raw Files: {args.keep_raw}")
            return 0
        
        # Initialize results
        results = {
            'start_time': datetime.now().isoformat(),
            'targets': targets,
            'date': args.date or 'latest'
        }
        
        # Create authentication handler
        auth = JplatpatAuth(headless=not args.no_headless)
        
        try:
            # Setup driver and login
            logger.info("Setting up browser driver...")
            auth.setup_driver()
            
            logger.info("Attempting to login to J-PlatPat...")
            if not auth.login():
                logger.error("Failed to login to J-PlatPat")
                return 1
            
            logger.info("Login successful")
            
            # Create downloader
            downloader = JplatpatDownloader(auth.driver)
            
            # Download all targets
            logger.info("Starting downloads...")
            download_results = downloader.download_all(targets, args.date)
            results['download'] = download_results
            
            # Extract downloaded files
            if download_results['success'] > 0:
                logger.info("Starting extraction...")
                extraction_results = FileExtractor.process_downloads(
                    download_results, 
                    keep_raw=args.keep_raw
                )
                results['extraction'] = extraction_results
            else:
                logger.warning("No files downloaded successfully, skipping extraction")
            
        finally:
            # Cleanup
            auth.logout()
            auth.close()
        
        # Save results
        results['end_time'] = datetime.now().isoformat()
        results_file = save_results(results, Config.LOG_DIR)
        
        # Print summary
        print_summary(results)
        
        if results_file:
            print(f"\nDetailed results saved to: {results_file}")
        
        # Determine exit code
        if results.get('download', {}).get('failed', 0) > 0:
            return 2  # Partial success
        
        return 0  # Success
        
    except KeyboardInterrupt:
        logger.info("Process interrupted by user")
        return 130
        
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}", exc_info=True)
        return 1


if __name__ == '__main__':
    sys.exit(main())