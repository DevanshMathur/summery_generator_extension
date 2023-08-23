# OpenAI settings
OPENAI_API_KEY = 'your-openai-api-key'
DEFAULT_SITE_URL = 'https://en.wikipedia.org/wiki/Artificial_intelligence'
ENGINE = 'text-davinci-003'
MAX_TOKENS = 500
TEMPERATURE = 0.3
PROMPT_FOR_SUMMARY = '''Being an AI, Create a website summary for the given text in 200 words. 
Please also format the text and re-phrase it so that it is meaningful and gramatically correct
You need to re-correct english but facts and points must not be changed. You can correct grammar.

Since response will be in a paragraph so kindly add line breaks also so that its easier to read.

\n{0}'''

PROMPT_FOR_POINTS = '''Being an AI, Create a pointwise website summary for the given text in 6 points only. 
You need to re-correct english but facts and points must not be changed. You can correct grammar.
Example: 
1. xyz
2. pqr
etc..

Please also format the text and re-phrase it so that it is meaningful and gramatically correct.
You could recorrect english but facts and points must not be changed. You can correct grammar.


\n{0}

'''

# Server settings
HOST = "0.0.0.0"
PORT = 3010
