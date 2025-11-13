from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello World", 200

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'service': 'demo-app',
        'version': '1.0.0'
    }), 200

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)

