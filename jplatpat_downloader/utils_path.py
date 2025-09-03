#!/usr/bin/env python3
"""Path normalization utilities for cross-platform compatibility."""

import os
import re
import platform
from pathlib import Path
import logging

logger = logging.getLogger(__name__)


def normalize_path(p: str) -> str:
    """
    Normalize path for current environment.
    
    - On Windows: Convert WSL paths to Windows paths
    - On WSL/Linux: Keep paths as-is
    
    Args:
        p: Input path string
        
    Returns:
        Normalized path string
    """
    if not p:
        return str(Path.cwd())
    
    p = os.path.expanduser(p)
    p = str(p)  # Ensure string
    
    # Check if we're on Windows or WSL
    if platform.system() == 'Windows':
        # Running on Windows - normalize to Windows path
        return normalize_to_windows_path(p)
    else:
        # Running on WSL/Linux - normalize to Linux path
        return normalize_to_linux_path(p)


def normalize_to_windows_path(p: str) -> str:
    """
    Convert any path format to Windows absolute path.
    
    - '/mnt/c/...' -> 'C:\\...'
    - '\\mnt\\c\\...' -> 'C:\\...'
    - Relative paths -> Absolute Windows paths
    """
    # Replace forward slashes for consistency
    p = p.replace('\\', '/')
    
    # Match /mnt/c/... pattern
    m = re.match(r'^/mnt/([a-zA-Z])/(.*)$', p)
    if m:
        drive = m.group(1).upper()
        rest = m.group(2).replace('/', '\\')
        result = f"{drive}:\\{rest}" if rest else f"{drive}:\\"
        logger.debug(f"Converted WSL path {p} to Windows path {result}")
        return result
    
    # Match \\mnt\\c\\... pattern (already has backslashes)
    m = re.match(r'^\\\\?mnt\\\\([a-zA-Z])\\\\(.*)$', p)
    if m:
        drive = m.group(1).upper()
        rest = m.group(2)
        result = f"{drive}:\\{rest}" if rest else f"{drive}:\\"
        logger.debug(f"Converted malformed path {p} to Windows path {result}")
        return result
    
    # Already a Windows path or relative path
    return str(Path(p).resolve())


def normalize_to_linux_path(p: str) -> str:
    """
    Convert any path format to Linux/WSL path.
    
    - 'C:\\...' -> '/mnt/c/...'
    - '\\mnt\\c\\...' -> '/mnt/c/...'
    - Relative paths -> Absolute Linux paths
    """
    # Replace backslashes with forward slashes
    p = p.replace('\\', '/')
    
    # Match C:\... or C:/... pattern
    m = re.match(r'^([a-zA-Z]):[\\/](.*)$', p)
    if m:
        drive = m.group(1).lower()
        rest = m.group(2).replace('\\', '/')
        result = f"/mnt/{drive}/{rest}" if rest else f"/mnt/{drive}"
        logger.debug(f"Converted Windows path {p} to WSL path {result}")
        return result
    
    # Match \\mnt\\c\\... or /mnt/c/... pattern (fix malformed)
    m = re.match(r'^[\\/]+mnt[\\/]([a-zA-Z])[\\/](.*)$', p)
    if m:
        drive = m.group(1).lower()
        rest = m.group(2).replace('\\', '/')
        result = f"/mnt/{drive}/{rest}" if rest else f"/mnt/{drive}"
        logger.debug(f"Fixed malformed path {p} to WSL path {result}")
        return result
    
    # Already a Linux path or relative path
    return str(Path(p).resolve())


def get_download_directories():
    """
    Get all possible download directories to check.
    
    Returns:
        List of Path objects for download directories
    """
    from config import Config
    
    dirs = []
    
    # Primary download directory
    primary = normalize_path(str(Config.DOWNLOAD_DIR))
    dirs.append(Path(primary))
    
    # Windows Downloads folder
    if platform.system() == 'Windows':
        downloads = Path.home() / 'Downloads'
    else:
        # WSL - check Windows Downloads
        downloads = Path('/mnt/c/Users/ygenk/Downloads')
    
    if downloads.exists():
        dirs.append(downloads)
    
    # Remove duplicates while preserving order
    seen = set()
    unique_dirs = []
    for d in dirs:
        if d not in seen:
            seen.add(d)
            unique_dirs.append(d)
    
    return unique_dirs


def ensure_directory(path: str) -> Path:
    """
    Ensure directory exists, creating if necessary.
    
    Args:
        path: Directory path
        
    Returns:
        Path object for the directory
    """
    normalized = normalize_path(path)
    dir_path = Path(normalized)
    dir_path.mkdir(parents=True, exist_ok=True)
    return dir_path


# For backward compatibility
def normalize_windows_path(p: str) -> str:
    """Legacy function name - redirects to normalize_to_windows_path."""
    return normalize_to_windows_path(p)