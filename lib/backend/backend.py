from fastapi import FastAPI
from pydantic import BaseModel
import tensorflow as tf
import numpy as np
import re
import string
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'


# Load the trained model
model = tf.keras.models.load_model("combined_emotion_sentiment_analysis_model.h5")

# Define FastAPI app
app = FastAPI()

# Define input structure
class TextInput(BaseModel):
    text: str

# Function to preprocess text
def preprocess_text(text):
    text = text.lower()
    text = re.sub(f"[{string.punctuation}]", "", text)  # Remove punctuation
    return text

# Example tokenizer (Ensure you use the same tokenizer as used in training)
tokenizer = Tokenizer(num_words=2000, oov_token="<OOV>")  # Adjust num_words based on training
max_length = 32  # Adjust based on training

@app.get("/predict")  # Remove trailing slash
async def predict(input: TextInput):
    text = preprocess_text(input.text)
    sequence = tokenizer.texts_to_sequences([text])
    padded_sequence = pad_sequences(sequence, maxlen=max_length, padding="post")

    # Make prediction
    prediction = model.predict(padded_sequence)
    predicted_label = np.argmax(prediction, axis=1)[0]  # Get highest probability class

    # Map predicted label to emotion (Modify based on training labels)
    emotion_labels = {"Happy", "Sad", "Angry", "Fear", "Surprised", "Love"}
    detected_emotion = emotion_labels.get(predicted_label, "Unknown")

    return {"emotion": detected_emotion}

