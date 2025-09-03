#!/usr/bin/env python3
"""Configuration management for J-PlatPat downloader."""

import os
from pathlib import Path
from typing import List, Optional
from dotenv import load_dotenv

# Load environment variables
env_path = Path(__file__).parent.parent / '.env'
load_dotenv(env_path)


class Config:
    """Configuration class for J-PlatPat downloader."""
    
    # Authentication
    JPLATPAT_USERNAME = os.getenv('JPLATPAT_USERNAME', '')
    JPLATPAT_PASSWORD = os.getenv('JPLATPAT_PASSWORD', '')
    
    # URLs
    LOGIN_URL = 'https://www.j-platpat.inpit.go.jp/?uri=/c1000'
    BASE_URL = 'https://www.j-platpat.inpit.go.jp'
    
    # Directories
    BASE_DIR = Path(__file__).parent.parent
    
    # Handle Windows vs WSL paths
    import platform
    if platform.system() == 'Windows':
        # Windows paths
        DOWNLOAD_DIR = Path(os.getenv('DOWNLOAD_DIR', str(BASE_DIR / 'downloads' / 'raw')))
        EXTRACT_DIR = Path(os.getenv('EXTRACT_DIR', str(BASE_DIR / 'downloads' / 'extracted')))
        LOG_DIR = Path(os.getenv('LOG_DIR', str(BASE_DIR / 'logs')))
        TSV_DATA_DIR = Path(os.getenv('TSV_DATA_DIR', str(BASE_DIR / 'tsv_data' / 'tsv')))
    else:
        # WSL paths
        DOWNLOAD_DIR = Path(os.getenv('DOWNLOAD_DIR', str(BASE_DIR / 'downloads' / 'raw')))
        EXTRACT_DIR = Path(os.getenv('EXTRACT_DIR', str(BASE_DIR / 'downloads' / 'extracted')))
        LOG_DIR = Path(os.getenv('LOG_DIR', str(BASE_DIR / 'logs')))
        TSV_DATA_DIR = Path(os.getenv('TSV_DATA_DIR', str(BASE_DIR / 'tsv_data' / 'tsv')))
    
    # Browser settings
    HEADLESS_MODE = os.getenv('HEADLESS_MODE', 'True').lower() == 'true'
    
    # Retry settings
    RETRY_COUNT = int(os.getenv('RETRY_COUNT', '3'))
    TIMEOUT = int(os.getenv('TIMEOUT', '120'))
    
    # Download targets
    DOWNLOAD_TARGETS = os.getenv('DOWNLOAD_TARGETS', '').split(',')
    
    # Target descriptions - exact text as shown on the page
    TARGET_DESCRIPTIONS = {
        'JPWAC': '[Weekly_Update] 申請人登録マスタ(Weekly_Update_Data_Applicantm)',
        'JPWAT': '[Weekly_Update] 出願マスタ（商標）(Weekly_Update_Data_Appm_Trademark)',
        'JPWDI': '[Weekly_Update] 商標見本ファイル(Weekly_Update_Data_Image)',
        'JPWMG': '[Weekly_Update] マドプロ原簿マスタ(Weekly_Update_Data_Madregm)',
        'JPWMP': '[Weekly_Update] マドプロ出願マスタ(Weekly_Update_Data_Madprom)',
        'JPWRT': '[Weekly_Update] 登録マスタ(商標)(Weekly_Update_Data_Registrm_Trademark)',
        'JPWT': '[Weekly_Update] 商標基本マスタ(Weekly_Update_Data_Tmarkm)',
        'JPWSA': '[Weekly_Update]共有DB(審判)(Weekly_Update_Data_SharedDB_Appeal)'
    }
    
    # File patterns for each target - support both .zip and .tar.gz
    FILE_PATTERNS = {
        'JPWAC': 'JPWAC*.tar.gz',
        'JPWAT': 'JPWAT*.tar.gz',
        'JPWDI': 'JPWDI*.tar.gz',
        'JPWMG': 'JPWMG*.tar.gz',
        'JPWMP': 'JPWMP*.tar.gz',
        'JPWRT': 'JPWRT*.tar.gz',
        'JPWT': 'JPWT*.tar.gz',
        'JPWSA': 'JPWSA*.tar.gz'
    }
    
    @classmethod
    def validate(cls) -> bool:
        """Validate configuration."""
        if not cls.JPLATPAT_USERNAME or not cls.JPLATPAT_PASSWORD:
            raise ValueError("J-PlatPat credentials not configured")
        
        if not cls.DOWNLOAD_TARGETS or cls.DOWNLOAD_TARGETS == ['']:
            raise ValueError("No download targets specified")
        
        # Create directories if they don't exist
        for dir_path in [cls.DOWNLOAD_DIR, cls.EXTRACT_DIR, cls.LOG_DIR]:
            dir_path.mkdir(parents=True, exist_ok=True)
        
        return True
    
    @classmethod
    def get_target_dir(cls, target: str, date: Optional[str] = None) -> Path:
        """Get directory for specific target and date."""
        if date:
            return cls.EXTRACT_DIR / target / date
        return cls.EXTRACT_DIR / target / 'latest'
    
    @classmethod
    def get_tsv_dir(cls, date: str) -> Path:
        """Get TSV directory for specific date."""
        return cls.TSV_DATA_DIR / date