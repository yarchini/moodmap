import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing.sequence import pad_sequences
import pickle

# Load the saved LSTM model
model = tf.keras.models.load_model("combined_emotion_sentiment_analysis_model.h5")

# Load tokenizer used during training
with open("tokenizer", "rb") as handle:
    tokenizer = pickle.load(handle)

# Load label encoder used during training
with open("label_encoder.pickle", "rb") as handle:
    label_encoder = pickle.load(handle)

# Function to preprocess input text
def preprocess_text(text, tokenizer, max_length=100):
    sequence = tokenizer.texts_to_sequences([text])  # Convert text to sequence
    padded_sequence = pad_sequences(sequence, maxlen=max_length, padding="post")
    return padded_sequence

# Function to predict emotion
def predict_emotion(text):
    processed_text = preprocess_text(text, tokenizer)
    prediction = model.predict(processed_text)
    predicted_label_index = np.argmax(prediction)  # Get index of highest probability
    predicted_emotion = label_encoder.inverse_transform([predicted_label_index])  # Decode label
    return predicted_emotion[0]

# Example test cases
test_sentences = [
    "I am very happy today!",   # Expected: Joy
    "I feel so sad and lonely.", # Expected: Sadness
    "I am extremely angry right now!", # Expected: Anger
    "I am really scared of what will happen next.", # Expected: Fear
    "I feel nothing at all." # Expected: Neutral
]

# Run predictions
for sentence in test_sentences:
    emotion = predict_emotion(sentence)
    print(f"Text: {sentence}\nPredicted Emotion: {emotion}\n")
