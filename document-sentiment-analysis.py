from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch
import re
import numpy as np
import pandas as pd
import os
import pdfplumber


years = range(2001, 2022)
directory = "/Users/omar/TIM/UTC-doc-registry/"
tokenizer = AutoTokenizer.from_pretrained('nlptown/bert-base-multilingual-uncased-sentiment')
model = AutoModelForSequenceClassification.from_pretrained('nlptown/bert-base-multilingual-uncased-sentiment')
key_words = ['ESC', 'emoji subcommittee', 'emoji gender', 'skintone', 'multi-person. multi-skintone', 'fitzpatrick scale', 'gender', 'gendered', 'male', 'female', 'gender inclusive', 'male/female', 'UTR #51', 'gender neutral', 'feminine', 'masculine', 'gender inequality', 'inclusive gender', 'gender-related', 'binary gender', 'neutral gender', 'TR-51', 'racial', 'racial representation,' 'racial homogeniety', 'light-skin', 'people of color', 'people of colour', 'racial composition', 'ethnic', 'ethnic background', 'racial stereotypes', 'golliwog', 'western', 'race', 'skin color', 'racial differences']
key_people = ['Jennifer Daniels', 'Mark Davies', 'Charlotte Buff', 'Michael Kieran', 'Alex King', 'Scott Hill', 'Paul Roberts', 'Jeremy Burge']

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

def get_doc_contents(document_path):
    if document_path.endswith('.pdf'):
        contents = get_pdf_contents(document_path)
    else:
        with open(document_path, errors='ignore') as file:
            contents = file.read()
    return contents

def get_pdf_contents(document_path):
    contents = []
    with pdfplumber.open(document_path) as pdf:
        for page in pdf.pages:
            contents.append(page.extract_text())
    return " ".join(contents)

def word_finder(document_path):
    contents = get_doc_contents(document_path)
    for search_word in key_words:
        if search_word in contents:
            print (f'word "{search_word}" found in {document_path}')

# Testing
def year_search_iterate(year):
    curr_directory = path(year)
    for filename in os.listdir(curr_directory):
        f = os.path.join(curr_directory, filename)
        if os.path.isfile(f):
            word_finder(f)
#Testing

def main():
    for year in years:
        year_search_iterate(year)

if __name__ == '__main__':
    main()
