"""
Database-specific tests for TMCloud.
"""

import os
import sqlite3
import pytest


class TestDatabase:
    """Test database functionality with the CI test database."""
    
    @pytest.fixture
    def db_connection(self):
        """Fixture to provide database connection."""
        db_path = 'test_data/test_ci.db'
        if not os.path.exists(db_path):
            pytest.skip("Test database not available")
        
        conn = sqlite3.connect(db_path)
        yield conn
        conn.close()
    
    def test_database_schema(self, db_connection):
        """Test that all required tables exist with correct schema."""
        cursor = db_connection.cursor()
        
        # Get table information
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
        tables = [row[0] for row in cursor.fetchall()]
        
        # Required tables
        required_tables = [
            'jiken_c_t',
            'standard_char_t_art', 
            'goods_class_art',
            'right_person_art_t'
        ]
        
        for table in required_tables:
            assert table in tables, f"Required table {table} missing"
    
    def test_data_integrity(self, db_connection):
        """Test data integrity in test database."""
        cursor = db_connection.cursor()
        
        # Test that primary table has data
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t")
        count = cursor.fetchone()[0]
        assert count >= 5, f"Expected at least 5 test records, got {count}"
        
        # Test that related data exists
        cursor.execute("SELECT COUNT(*) FROM standard_char_t_art")
        standard_count = cursor.fetchone()[0]
        assert standard_count > 0, "Standard character data should exist"
        
        cursor.execute("SELECT COUNT(*) FROM goods_class_art")
        goods_count = cursor.fetchone()[0]
        assert goods_count > 0, "Goods classification data should exist"
    
    def test_search_queries(self, db_connection):
        """Test various search query patterns."""
        cursor = db_connection.cursor()
        
        # Test application number search
        cursor.execute("SELECT * FROM jiken_c_t WHERE app_num = ?", ('2024000001',))
        result = cursor.fetchone()
        assert result is not None, "Should find test trademark 2024000001"
        
        # Test name search
        cursor.execute("SELECT * FROM jiken_c_t WHERE app_name LIKE ?", ('%TEST%',))
        results = cursor.fetchall()
        assert len(results) > 0, "Should find trademarks with 'TEST' in name"
        
        # Test join query
        cursor.execute("""
            SELECT j.app_num, j.app_name, s.standard_char_name
            FROM jiken_c_t j
            LEFT JOIN standard_char_t_art s ON j.app_num = s.app_num
            WHERE j.app_num = ?
        """, ('2024000001',))
        
        result = cursor.fetchone()
        assert result is not None, "Join query should return results"
        assert result[0] == '2024000001', "Should return correct application number"
    
    def test_indexes_exist(self, db_connection):
        """Test that required indexes exist for performance."""
        cursor = db_connection.cursor()
        
        # Get index information
        cursor.execute("SELECT name FROM sqlite_master WHERE type='index'")
        indexes = [row[0] for row in cursor.fetchall()]
        
        # Expected indexes (created by test database script)
        expected_indexes = [
            'idx_jiken_app_name',
            'idx_standard_char_name',
            'idx_goods_class_no'
        ]
        
        for index in expected_indexes:
            assert index in indexes, f"Required index {index} missing"