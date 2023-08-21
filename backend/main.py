from flask import Flask, request
from bs4 import BeautifulSoup
import requests
from gensim.summarization.summarizer import summarize
import openai

from response_model import ResponseModel, response_model_from_dict

app = Flask(__name__)

# OpenAI API Key
openai.api_key = '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'

@app.route('/', methods = ['GET', 'POST'])
def handle_request():
    # Get the input from the request
    text = str(request.args.get('input'))

    # Count the number of characters in the input
    char_count = len(text)

    # Return the summary of the input text
    return get_summary(text)

def get_summary(url):
    # Send a GET request to the url
    page = requests.get(url)

    # Parse the page
    soup = BeautifulSoup(page.text, "html.parser")

    # Summarize the parsed text
    summary = summarize(soup.text, ratio = 0.5)

    try:
        # Use OpenAI's GPT-3 model to further summarize the text
        response = openai.Completion.create(
            engine = 'text-davinci-003',
            max_tokens = 1024,
            n=1,
            stop = None,
            temperature = 0.3,
            prompt = "Create a summary for the given text: {0} in 200 words. Please also format the text and re-phrase it.".format(summary)
        )
        responseModel = response_model_from_dict(response)
        # Get the text from the response
        summary_text = responseModel.choices[0].text

        return summary_text

    except Exception as e:
        return str(e)

if __name__ == "__main__":
    app.run(debug = True, host = "0.0.0.0", port = 3010)