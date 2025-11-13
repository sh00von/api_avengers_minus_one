import unittest
from app.app import app

class TestApp(unittest.TestCase):
    
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True
    
    def test_hello_endpoint(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data.decode('utf-8'), 'Hello World')
    
    def test_health_endpoint(self):
        response = self.app.get('/health')
        self.assertEqual(response.status_code, 200)
        data = response.get_json()
        self.assertIsNotNone(data)
        self.assertEqual(data['status'], 'healthy')
        self.assertEqual(data['service'], 'demo-app')
        self.assertIn('version', data)
    
    def test_health_endpoint_structure(self):
        response = self.app.get('/health')
        data = response.get_json()
        self.assertIsInstance(data, dict)
        self.assertIn('status', data)
        self.assertIn('service', data)
        self.assertIn('version', data)

if __name__ == '__main__':
    unittest.main()

