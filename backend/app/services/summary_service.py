import openai
from decouple import config

from backend.app.api.utils import summarize_text_2, extract_text, get_gpt3_summary
from backend.config.constants import OPENAI_API_KEY

# OpenAI API Key
openai.api_key = config('api_key', default=OPENAI_API_KEY)


def get_website_summary(url, isPoints):
    text = extract_text(url)
    # summary = summarize_text(text)
    summary = summarize_text_2(text, word_count=500)
    # return summary
    return get_gpt3_summary(summary, isPoints)
