import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
import string
import numpy as np
import pandas as pd
from tensorflow.keras.models import load_model
from tensorflow.keras.utils import pad_sequences
import pickle

# Download necessary NLTK data
nltk.download('punkt')
nltk.download('stopwords')

# Data cleaning function
def clean_tweet(text):
    tokens = word_tokenize(text)
    tokens = [w.lower() for w in tokens]

    # Remove punctuation
    table = str.maketrans('', '', string.punctuation)
    stripped = [w.translate(table) for w in tokens]
    words = [word for word in stripped if word.isalpha()]

    # Remove stopwords
    stop_words = stopwords.words('english')
    words = [w for w in words if w not in stop_words]

    # Stemming
    porter = PorterStemmer()
    stemmed_words = [porter.stem(word) for word in words]
    return ' '.join(stemmed_words)

# Load the trained model
model_path = r"C:\Users\ASUS\Desktop\MoodMap FYP\h5 files\combine1_emotion_classification_model.h5"
model = load_model(model_path)

# Load the tokenizer
tokenizer_path = r"combine_tokenizer.pkl"
with open(tokenizer_path, 'rb') as handle:
    tokenizer = pickle.load(handle)

# Load the dataset
data_path = r"C:\Users\ASUS\Downloads\combined_emotion.csv"
data = pd.read_csv(data_path)
emotion_labels = pd.get_dummies(data['emotion']).columns

# Preprocess a single tweet
def preprocess_tweet(tweet):
    cleaned_tweet = clean_tweet(tweet)
    tweet_seq = tokenizer.texts_to_sequences([cleaned_tweet])
    tweet_pad = pad_sequences(tweet_seq, maxlen=32)
    return tweet_pad

# Predict sentiment for new tweets
sample_tweets = [
    "I just feel so helpless and scared.",
    "I am extremely happy with my life!",
    "This is a very disappointing and sad experience.",
    "Feeling confused and unsure about what to do.",
    "What a lovely and romantic evening!"
]

for tweet in sample_tweets:
    processed_tweet = preprocess_tweet(tweet)
    prediction = model.predict(processed_tweet)
    predicted_label_index = np.argmax(prediction)
    predicted_sentiment = emotion_labels[predicted_label_index]
    print(f"Sentence: '{tweet}'")
    print(f"Predicted Emotion: {predicted_sentiment}\n")
