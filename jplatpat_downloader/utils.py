#!/usr/bin/env python3
"""Utility functions for J-PlatPat downloader."""

import os
import json
import logging
from pathlib import Path
from datetime import datetime
from typing import Dict, Any

logger = logging.getLogger(__name__)


def setup_logging(log_dir: Path, log_level: str = 'INFO') -> None:
    """Setup logging configuration."""
    log_dir.mkdir(parents=True, exist_ok=True)
    
    # Create log file with timestamp
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    log_file = log_dir / f'jplatpat_downloader_{timestamp}.log'
    
    # Configure logging
    logging.basicConfig(
        level=getattr(logging, log_level.upper()),
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file),
            logging.StreamHandler()
        ]
    )
    
    logger.info(f"Logging initialized. Log file: {log_file}")


def save_results(results: Dict, output_dir: Path) -> Path:
    """Save download/extraction results to JSON file."""
    try:
        output_dir.mkdir(parents=True, exist_ok=True)
        
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        output_file = output_dir / f'results_{timestamp}.json'
        
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(results, f, ensure_ascii=False, indent=2)
        
        logger.info(f"Results saved to {output_file}")
        return output_file
        
    except Exception as e:
        logger.error(f"Error saving results: {str(e)}")
        return None


def format_size(size_bytes: int) -> str:
    """Format file size in human-readable format."""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if size_bytes < 1024.0:
            return f"{size_bytes:.2f} {unit}"
        size_bytes /= 1024.0
    return f"{size_bytes:.2f} PB"


def validate_date(date_str: str) -> bool:
    """Validate date string format (YYYYMMDD)."""
    try:
        if len(date_str) != 8:
            return False
        datetime.strptime(date_str, '%Y%m%d')
        return True
    except ValueError:
        return False


def get_latest_file(directory: Path, pattern: str) -> Path:
    """Get the most recent file matching pattern in directory."""
    files = list(directory.glob(pattern))
    if not files:
        return None
    return max(files, key=lambda f: f.stat().st_mtime)


def clean_old_logs(log_dir: Path, keep_days: int = 7) -> None:
    """Clean old log files."""
    try:
        cutoff_time = datetime.now().timestamp() - (keep_days * 86400)
        
        for log_file in log_dir.glob('*.log'):
            if log_file.stat().st_mtime < cutoff_time:
                log_file.unlink()
                logger.info(f"Deleted old log file: {log_file}")
                
    except Exception as e:
        logger.error(f"Error cleaning old logs: {str(e)}")


def print_summary(results: Dict) -> None:
    """Print a summary of download/extraction results."""
    print("\n" + "="*60)
    print("DOWNLOAD SUMMARY")
    print("="*60)
    
    if 'download' in results:
        download = results['download']
        print(f"\nDownload Results:")
        print(f"  Total targets: {download['total']}")
        print(f"  Successful: {download['success']}")
        print(f"  Failed: {download['failed']}")
        
        if download['targets']:
            print("\n  Target Details:")
            for target, info in download['targets'].items():
                status = "✓" if info['status'] == 'success' else "✗"
                print(f"    {status} {target}: {info['status']}")
                if info.get('error'):
                    print(f"      Error: {info['error']}")
    
    if 'extraction' in results:
        extraction = results['extraction']
        print(f"\nExtraction Results:")
        print(f"  Total files: {extraction['total']}")
        print(f"  Successful: {extraction['success']}")
        print(f"  Failed: {extraction['failed']}")
        
        if extraction['targets']:
            print("\n  Extraction Details:")
            for target, info in extraction['targets'].items():
                status = "✓" if info['status'] == 'success' else "✗"
                print(f"    {status} {target}: {info['status']}")
                if info.get('extracted_to'):
                    print(f"      Location: {info['extracted_to']}")
    
    print("\n" + "="*60)


def check_disk_space(path: Path, required_gb: float = 10.0) -> bool:
    """Check if sufficient disk space is available."""
    try:
        import shutil
        stat = shutil.disk_usage(path)
        available_gb = stat.free / (1024**3)
        
        if available_gb < required_gb:
            logger.warning(f"Low disk space: {available_gb:.2f} GB available, {required_gb:.2f} GB recommended")
            return False
        
        logger.info(f"Disk space check passed: {available_gb:.2f} GB available")
        return True
        
    except Exception as e:
        logger.error(f"Error checking disk space: {str(e)}")
        return True  # Continue anyway if check fails