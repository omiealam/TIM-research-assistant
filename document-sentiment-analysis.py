from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch
import re
import numpy as np
import pandas as pd
import os

years = range(2001, 2022)
directory = "/Users/omar/TIM/UTC-doc-registry/"
tokenizer = AutoTokenizer.from_pretrained('nlptown/bert-base-multilingual-uncased-sentiment')
model = AutoModelForSequenceClassification.from_pretrained('nlptown/bert-base-multilingual-uncased-sentiment')

def sentiment_score(text):
    tokens = tokenizer.encode(text, return_tensors='pt')
    result = model(tokens)
    return int(torch.argmax(result.logits))+1

def path(year):
    return f'{directory}{year}/L2'

for year in years:
    print(path(year))

# for filename in os.listdir(directory):
#     f = os.path.join(directory, filename)
#     # checking if it is a file
#     if os.path.isfile(f):
#         print(f)
