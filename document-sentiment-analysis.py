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

def year_iterate(year):
    curr_directory = path(year)
    for filename in os.listdir(curr_directory):
        f = os.path.join(curr_directory, filename)
        if os.path.isfile(f):
            print(f'{filename} {sentiment_score(filename)}')

def main():

if __name__ == '__main__':
    main()
