from flask import Flask

from backend.app.api.routes import api
from backend.config.constants import HOST, PORT
from flask_cors import CORS
app = Flask(__name__)
CORS(app)
app.register_blueprint(api)

if __name__ == "__main__":
    app.run(debug=True, host=HOST, port=PORT)
