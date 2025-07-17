# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TMCloud is a trademark search system that processes Japanese Patent Office (JPO) data. The system provides searchable access to both domestic and international trademark registrations through a web interface and CLI tools.

## Key Architecture

### Database Structure
- **SQLite database** (`output.db`) with normalized schema
- **Two main datasets**: Domestic trademarks (jiken_c_t) and International trademarks (intl_trademark_registration)
- **Foreign key relationships** maintained with normalized application numbers (hyphens removed)
- **Search optimization**: Uses indexed columns and single JOIN queries (avoid N+1 patterns)

### Data Flow
```
TSV Files (JPO weekly updates) → Import Scripts → SQLite Database → Search APIs → Web UI/CLI
```

### Critical Tables for Search
- `search_use_t_art_table` - Primary search table (検索用商標)
- `jiken_c_t_shohin_joho` - Goods/services with class (rui) information
- `standard_char_t_art` - Standard character trademarks
- `applicant_master` - Applicant information

## Common Commands

### Development
```bash
# Run Flask web application
python app_dynamic_join_claude_optimized.py

# CLI trademark search
python cli_trademark_search.py --mark-text "商標名"
python correct_trademark_search.py --mark-text "商標名" --limit 30

# Generate HTML search results
python correct_html_generator.py --mark-text "商標名" --limit 30

# Run tests
pytest tests/
pytest tests/test_specific_module.py::test_function_name  # Single test

# Linting
ruff check .
black . --check
```

### Database Operations
```bash
# Initialize database
python init_database.py

# Import TSV data
python import_tsv_data_fixed.py

# Weekly data update
python weekly_data_updater.py --tsv-dir tsv_data/YYMMDD/

# Fix foreign key integrity
python fix_foreign_key_integrity_v2.py

# Add rui column (if missing)
python add_rui_column_to_goods_table.py

# Convert TSV image data to JPG files
python tsv_to_image_converter.py

# Validate existing image files
python tsv_to_image_converter.py --validate-only
```

## Search Implementation Notes

### Correct Search Approach
1. **Search in `search_use_t_art_table`** for trademark text (not standard_char_t_art)
2. **Get application numbers** from search results
3. **Use application numbers as primary keys** to fetch data from each table
4. **Avoid complex JOINs** in search queries - fetch data separately

### Key Search Files
- `correct_trademark_search.py` - Implements the correct search approach
- `correct_html_generator.py` - Generates HTML using correct search
- `cli_trademark_search.py` - Original CLI (uses JOIN approach - less optimal)

## Database Schema Changes

When modifying database structure:
1. **Always backup first**: `cp output.db output.db.backup`
2. **Check TSV specifications**: Refer to `TSV_COLUMN_SPECIFICATIONS.md`
3. **Maintain foreign key integrity**: Application numbers must be normalized (no hyphens)
4. **Update views if needed**: Drop and recreate views when changing underlying tables

## TSV Data Import

### File Naming Convention
- Directory format: `tsv_data/YYMMDD/` (e.g., `250611` = 2025/06/11)
- Weekly update files from JPO

### Critical Import Files
- `upd_jiken_c_t.tsv` - Main application data
- `upd_jiken_c_t_shohin_joho.tsv` - Goods/services with class (rui)
- `upd_search_use_t_art_table.tsv` - Search trademark text
- `upd_standard_char_t_art.tsv` - Standard character trademarks
- `upd_t_sample.tsv` - Trademark image data (Base64 encoded)

### Import Considerations
- TSV files are weekly updates, not complete datasets
- Older trademarks may lack class (rui) information
- Character encoding: UTF-8
- Application numbers in TSV may have hyphens - normalize on import

## Image Data Processing

### TSV Image Conversion
- **Script**: `tsv_to_image_converter.py` - **CRITICAL: DO NOT DELETE**
- **Source**: `tsv_data/250611/upd_t_sample.tsv` (10,063 records)
- **Output**: `images/final_complete/` (1,508 valid JPG files)
- **Database**: Updates `t_sample` table with `has_image_file` status

### Image Data Format
- Valid JPEG Base64 data starts with `/9j/`
- Invalid data (majority) starts with `////` - these are filtered out
- Only valid JPEG data is converted to JPG files
- Files are named using normalized application numbers (no hyphens)

### Image Processing Commands
```bash
# Convert all TSV image data to JPG files
python tsv_to_image_converter.py

# Validate existing image files only
python tsv_to_image_converter.py --validate-only

# Custom paths
python tsv_to_image_converter.py --tsv-file "path/to/tsv" --output-dir "path/to/output"
```

## Performance Requirements
- Search queries should complete in <1 second
- HTML generation should handle 100+ results efficiently
- Use pagination for large result sets

## Testing
- Test database available with sample data
- Run tests before committing changes
- Integration tests for database operations
- Performance benchmarks for search operations

## Common Issues and Solutions

### Missing Class Information
- Older trademarks (pre-2024) may show "調査中" for class
- This is expected due to TSV data limitations

### Foreign Key Violations
- Run `fix_foreign_key_integrity_v2.py` to fix reference issues
- Ensure application numbers are normalized (no hyphens)

### Search Not Finding Results
- Check if using `search_use_t_art_table` (not standard_char_t_art)
- Verify trademark text encoding (UTF-8)
- Confirm data exists in database for the search term

### Image Display Issues
- Ensure `tsv_to_image_converter.py` has been run to process image data
- Check `t_sample` table has `has_image_file` column with correct values
- Verify `images/final_complete/` directory contains JPG files
- Image files are named with normalized application numbers (no hyphens)

## System Architecture Overview

### Core Application Structure
```
TMCloud/
├── Web Application
│   ├── app_dynamic_join_claude_optimized.py (Flask web server)
│   ├── templates/ (HTML templates)
│   └── static/ (CSS, JS assets)
├── CLI Search Tools
│   ├── correct_trademark_search.py (Optimal search implementation)
│   ├── correct_html_generator.py (HTML output generation)
│   └── cli_trademark_search.py (Legacy CLI tool)
├── Database Management
│   ├── init_database.py (Database initialization)
│   ├── import_tsv_data_fixed.py (TSV data import)
│   └── output.db (Main SQLite database)
├── Data Processing
│   ├── tsv_to_image_converter.py (Image conversion)
│   ├── fix_foreign_key_integrity_v2.py (Data integrity)
│   └── add_rui_column_to_goods_table.py (Schema updates)
└── Configuration & Documentation
    ├── CLAUDE.md (This file)
    ├── TSV_COLUMN_SPECIFICATIONS.md (Data specifications)
    └── requirements.txt (Dependencies)
```

### Application Components by Function

#### 1. Web Interface (Production)
- **`app_dynamic_join_claude_optimized.py`** - **PRIMARY WEB APPLICATION**
  - Flask-based web server for trademark search
  - Handles HTTP requests and responses
  - Integrates with database and search functionality
  - **CRITICAL: Main user interface**

#### 2. Search Engine (Core)
- **`correct_trademark_search.py`** - **OPTIMAL SEARCH ENGINE**
  - Implements correct search methodology
  - Uses `search_use_t_art_table` as primary search source
  - Fetches data from multiple tables using application numbers
  - **CRITICAL: Core search logic**

- **`correct_html_generator.py`** - **HTML OUTPUT GENERATOR**
  - Generates modern HTML search results
  - Supports image display with proper fallbacks
  - Integrates with correct search engine
  - **CRITICAL: Search result presentation**

#### 3. Database Management (Infrastructure)
- **`init_database.py`** - **DATABASE INITIALIZATION**
  - Creates SQLite database schema
  - Sets up tables and relationships
  - **CRITICAL: Database setup**

- **`import_tsv_data_fixed.py`** - **TSV DATA IMPORTER**
  - Imports JPO weekly TSV files into database
  - Handles data normalization and validation
  - **CRITICAL: Data ingestion**

- **`output.db`** - **MAIN DATABASE**
  - SQLite database with all trademark data
  - Contains normalized and indexed data
  - **CRITICAL: Data storage**

#### 4. Data Processing (Maintenance)
- **`tsv_to_image_converter.py`** - **IMAGE CONVERSION SYSTEM**
  - Converts Base64 TSV image data to JPG files
  - Handles multi-line encoded data
  - Updates database with image file status
  - **CRITICAL: Image processing**

- **`fix_foreign_key_integrity_v2.py`** - **DATA INTEGRITY FIXER**
  - Resolves foreign key reference issues
  - Normalizes application numbers
  - **CRITICAL: Database maintenance**

- **`add_rui_column_to_goods_table.py`** - **SCHEMA UPDATER**
  - Adds class (rui) information to goods table
  - Imports class data from TSV files
  - **CRITICAL: Database evolution**

#### 5. Legacy Tools (Backup)
- **`cli_trademark_search.py`** - Legacy CLI search tool
- **`search_results_html_generator_improved.py`** - Legacy HTML generator
- **`search_results_html_generator_modern.py`** - Modern HTML generator (superseded)

#### 6. Configuration & Documentation
- **`CLAUDE.md`** - Developer documentation and instructions
- **`TSV_COLUMN_SPECIFICATIONS.md`** - TSV file format specifications
- **`requirements.txt`** - Python dependencies
- **`config.py`** - Application configuration

### Directory Structure Details

#### Essential Directories
- **`tsv_data/`** - **TSV input files from JPO**
  - `250611/` - Weekly update files (2025/06/11)
  - **CRITICAL: Data source**

- **`images/final_complete/`** - **Generated image files**
  - 1,508 JPG files from TSV conversion
  - Named by normalized application numbers
  - **CRITICAL: Image assets**

- **`templates/`** - **HTML templates for web interface**
  - Jinja2 templates for Flask application
  - **CRITICAL: Web UI**

- **`static/`** - **Static web assets**
  - CSS, JavaScript files
  - **CRITICAL: Web UI styling**

#### Supporting Directories
- **`csvs/`** - JPO specification files (CSV format)
- **`scripts/`** - Additional utility scripts
- **`tests/`** - Test files and test data
- **`archive/`** - Archived old versions and analysis scripts
- **`search_results/`** - Generated search result files

## Critical Files - DO NOT DELETE

### Tier 1: Essential System Components
- **`app_dynamic_join_claude_optimized.py`** - Main web application
- **`correct_trademark_search.py`** - Core search engine
- **`correct_html_generator.py`** - HTML generation
- **`tsv_to_image_converter.py`** - Image conversion system
- **`output.db`** - Main database
- **`requirements.txt`** - Dependencies

### Tier 2: Data Management & Maintenance
- **`init_database.py`** - Database initialization
- **`import_tsv_data_fixed.py`** - TSV data import
- **`fix_foreign_key_integrity_v2.py`** - Data integrity fixes
- **`add_rui_column_to_goods_table.py`** - Schema updates
- **`TSV_COLUMN_SPECIFICATIONS.md`** - Data specifications

### Tier 3: Data Sources & Assets
- **`tsv_data/250611/upd_t_sample.tsv`** - Original image data
- **`images/final_complete/`** - Generated JPG files (1,508 files)
- **`templates/`** - HTML templates
- **`static/`** - Web assets
- **`csvs/`** - JPO specification files