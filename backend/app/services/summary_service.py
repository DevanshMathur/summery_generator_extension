import openai
import requests
from bs4 import BeautifulSoup
from decouple import config
from gensim.summarization.summarizer import summarize

from backend.app.models.response_model import response_model_from_dict
from backend.config.constants import *
from backend.config.constants import ENGINE, MAX_TOKENS, TEMPERATURE, PROMPT_FORMAT

# OpenAI API Key
openai.api_key = config('api_key', default=OPENAI_API_KEY)


def extract_text(url):
    page = requests.get(url)
    soup = BeautifulSoup(page.text, "html.parser")
    return soup.text


def summarize_text(text):
    summary = summarize(text, ratio=0.5)
    while len(summary.split()) > 500:
        summary = summarize(summary, ratio=0.5)
    return summary


def get_gpt3_summary(summary):
    response = openai.Completion.create(engine=ENGINE, max_tokens=MAX_TOKENS, n=1, stop=None, temperature=TEMPERATURE,
                                        prompt=PROMPT_FORMAT.format(summary))

    responseModel = response_model_from_dict(response)
    return responseModel.choices[0].text


def get_website_summary(url):
    text = extract_text(url)
    summary = summarize_text(text)
    return get_gpt3_summary(summary)
