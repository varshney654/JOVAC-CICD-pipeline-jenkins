import os
from flask import Flask
from flask_cors import CORS
app = Flask(__name__)
CORS(app)
@app.route('/')
def index():
    return 'hello from service-b'
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
