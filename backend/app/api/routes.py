from flask import Blueprint, request
from backend.app.services.summary_service import get_website_summary

# Define a Flask Blueprint for your routes
api = Blueprint('api', __name__)


@api.route('/', methods=['GET', 'POST'])
def handle_request():
    url = str(request.args.get('input'))
    return get_website_summary(url)
