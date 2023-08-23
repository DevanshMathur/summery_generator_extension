import openai
import requests
from bs4 import BeautifulSoup
from gensim.summarization.summarizer import summarize

from backend.app.models.response_model import response_model_from_dict
from backend.config.constants import ENGINE, TEMPERATURE, MAX_TOKENS, PROMPT_FOR_SUMMARY, PROMPT_FOR_POINTS


def summarize_text_2(text, ratio=0.5, word_count=None):
    try:
        # Split the text into sentences
        sentences = text.split(". ")

        # Count the frequency of each word
        word_freq = {}
        for sentence in sentences:
            for word in sentence.split(" "):
                if word not in word_freq:
                    word_freq[word] = 0
                word_freq[word] += 1

        # Score sentences based on word frequency
        sentence_scores = {}
        for sentence in sentences:
            for word in sentence.split(" "):
                if sentence not in sentence_scores:
                    sentence_scores[sentence] = 0
                if word in word_freq:
                    sentence_scores[sentence] += word_freq[word]

        # Sort sentences by score
        sorted_sentences = sorted(sentence_scores.items(), key=lambda x: x[1], reverse=True)

        # Get the number of sentences to include in the summary
        if word_count:
            num_sentences = 0
            total_words = 0
            for sentence, score in sorted_sentences:
                if total_words + len(sentence.split(" ")) > word_count:
                    break
                total_words += len(sentence.split(" "))
                num_sentences += 1
        else:
            if not ratio:  # check if ratio is None or 0
                ratio = 0.5  # assign a default ratio
            num_sentences = int(len(sentences) * ratio)

        # Generate summary
        summary = ". ".join([sentence for sentence, score in sorted_sentences[:num_sentences]])

        return summary
    except Exception as e:
        return str(e)  # return the error message


def extract_text(url):
    page = requests.get(url)
    page.raise_for_status()
    soup = BeautifulSoup(page.text, "html.parser")
    return soup.text


def summarize_text(text):
    summary = text
    while True:
        if len(summary.split()) > 500:
            summary = summarize(summary, ratio=0.5, word_count=500)
            if summary == '':
                print("Summarization could not reduce the text to less than 500 words.")
                break
        break
    return summary


def get_gpt3_summary(summary, isPoints):
    try:
        if isPoints:
            prompt = PROMPT_FOR_POINTS.format(summary)
            print('//////////////\nPROMPT: {0}'.format(prompt))
            response = openai.Completion.create(engine=ENGINE, max_tokens=MAX_TOKENS, n=1, stop=None,
                                                temperature=TEMPERATURE, prompt=prompt)
        else:
            prompt = PROMPT_FOR_SUMMARY.format(summary)
            print('//////////////\nPROMPT: {0}'.format(prompt))
            response = openai.Completion.create(engine=ENGINE, max_tokens=MAX_TOKENS, n=1, stop=None,
                                                temperature=TEMPERATURE, prompt=prompt)
        print(response)
        responseModel = response_model_from_dict(response)
        return responseModel.choices[0].text
    except Exception as e:
        return Exception('Error calling chat-gpt')
