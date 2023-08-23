from flask import Blueprint, request
from backend.app.services.summary_service import get_website_summary
from backend.config.constants import *
# Define a Flask Blueprint for your routes
api = Blueprint('api', __name__)


@api.route('/', methods=['GET', 'POST'])
def home():
    url = request.args.get('input') or DEFAULT_SITE_URL
    points = request.args.get('points') or 'false'
    isPoints = points.lower() == 'true'
    summary =  get_website_summary(url, isPoints)
    return  summary
@api.route('/paragraph', methods=['GET', 'POST'])
def paragraph():
    url = request.args.get('input') or DEFAULT_SITE_URL
    summary =  get_website_summary(url, False)
    return  summary
@api.route('/points', methods=['GET', 'POST'])
def points():
    url = request.args.get('input') or DEFAULT_SITE_URL
    points = request.args.get('points') or 'false'
    summary =  get_website_summary(url, True)
    return  summary
