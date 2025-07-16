"""
Basic tests for TMCloud CI/CD pipeline.
These tests run on the lightweight test database.
"""

import os
import sqlite3
import tempfile
import pytest


def test_database_creation():
    """Test that we can create a basic database."""
    with tempfile.NamedTemporaryFile(suffix='.db', delete=False) as tmp:
        db_path = tmp.name
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        # Create a simple table
        cursor.execute('''
            CREATE TABLE test_table (
                id INTEGER PRIMARY KEY,
                name TEXT
            )
        ''')
        
        # Insert test data
        cursor.execute("INSERT INTO test_table (name) VALUES ('test')")
        conn.commit()
        
        # Verify data
        cursor.execute("SELECT COUNT(*) FROM test_table")
        count = cursor.fetchone()[0]
        assert count == 1
        
        conn.close()
        
    finally:
        if os.path.exists(db_path):
            os.unlink(db_path)


def test_test_database_exists():
    """Test that the CI test database was created."""
    db_path = 'test_data/test_ci.db'
    
    # Check if test database exists
    assert os.path.exists(db_path), f"Test database not found at {db_path}"
    
    # Check database connectivity
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Verify required tables exist
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
    tables = [row[0] for row in cursor.fetchall()]
    
    required_tables = ['jiken_c_t', 'standard_char_t_art', 'goods_class_art']
    for table in required_tables:
        assert table in tables, f"Required table {table} not found"
    
    # Check that tables contain data
    cursor.execute("SELECT COUNT(*) FROM jiken_c_t")
    count = cursor.fetchone()[0]
    assert count > 0, "jiken_c_t table should contain test data"
    
    conn.close()


def test_basic_search_functionality():
    """Test basic search functionality on test database."""
    db_path = 'test_data/test_ci.db'
    
    if not os.path.exists(db_path):
        pytest.skip("Test database not available")
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Test basic trademark search
    cursor.execute("SELECT * FROM jiken_c_t WHERE app_name LIKE ?", ('%ソニー%',))
    results = cursor.fetchall()
    
    # Should find Sony trademarks in test data
    assert len(results) > 0, "Should find Sony trademarks in test data"
    
    # Test goods classification search
    cursor.execute("SELECT * FROM goods_class_art WHERE goods_class_no = ?", ('09',))
    goods_results = cursor.fetchall()
    
    assert len(goods_results) > 0, "Should find class 09 goods in test data"
    
    conn.close()


def test_flask_imports():
    """Test that Flask and required modules can be imported."""
    try:
        import flask
        import sqlite3
        import json
        import os
        assert True
    except ImportError as e:
        pytest.fail(f"Failed to import required module: {e}")


def test_configuration():
    """Test basic configuration and environment setup."""
    # Test that we can create temporary files
    with tempfile.NamedTemporaryFile() as tmp:
        assert os.path.exists(tmp.name)
    
    # Test that required directories can be created
    test_dir = "test_temp_dir"
    os.makedirs(test_dir, exist_ok=True)
    assert os.path.isdir(test_dir)
    os.rmdir(test_dir)


if __name__ == "__main__":
    pytest.main([__file__])