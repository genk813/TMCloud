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

### Import Considerations
- TSV files are weekly updates, not complete datasets
- Older trademarks may lack class (rui) information
- Character encoding: UTF-8
- Application numbers in TSV may have hyphens - normalize on import

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