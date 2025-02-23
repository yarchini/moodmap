import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
import pandas as pd
import numpy as np
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, LSTM, Embedding
from tensorflow.keras.utils import pad_sequences
from tensorflow.keras.preprocessing.text import Tokenizer
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
import string
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

# Load dataset
data_path = r"C:\Users\ASUS\Downloads\combined_emotion.csv"
data = pd.read_csv(data_path)

# Ensure the dataset has required columns
if 'sentence' not in data.columns or 'emotion' not in data.columns:
    raise ValueError("Dataset must contain 'sentence' and 'emotion' columns.")

# Clean the data
data['clean_tweet'] = data['sentence'].apply(clean_tweet)

# Tokenization
max_words = 2000
tokenizer = Tokenizer(num_words=max_words, split=' ')
tokenizer.fit_on_texts(data['clean_tweet'].values)
X = tokenizer.texts_to_sequences(data['clean_tweet'].values)
X = pad_sequences(X, maxlen=32)

# Save the tokenizer for later use
tokenizer_path = r"combine_tokenizer.pkl"
with open(tokenizer_path, 'wb') as handle:
    pickle.dump(tokenizer, handle, protocol=pickle.HIGHEST_PROTOCOL)

# Convert 'emotion' labels to one-hot encoded format
dummies = pd.get_dummies(data['emotion'])
Y = dummies.values
emotion_labels = dummies.columns  # Ordered emotion labels

# Split data into training and testing sets
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2, random_state=50)

# Model creation
embedding_out_dim = 256
lstm_out_dim = 256
model = Sequential([
    Embedding(max_words, embedding_out_dim, input_length=X.shape[1]),
    LSTM(lstm_out_dim),
    Dense(len(emotion_labels), activation='softmax')
])
model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])

# Train the model
history = model.fit(
    X_train, Y_train,
    epochs=10, batch_size=512,
    validation_split=0.2
)

# Save the trained model
model_path = r"C:\Users\ASUS\Desktop\MoodMap FYP\h5 files\combine1_emotion_classification_model.h5"
model.save(model_path)
print(f"Model saved as '{model_path}'")

# Plot training and validation loss
plt.plot(history.history['loss'], 'r', label='Training loss')
plt.plot(history.history['val_loss'], 'b', label='Validation loss')
plt.title('Training and validation loss')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.legend()
plt.show()

# Plot training and validation accuracy
plt.plot(history.history['accuracy'], 'r', label='Training accuracy')
plt.plot(history.history['val_accuracy'], 'b', label='Validation accuracy')
plt.title('Training and validation accuracy')
plt.xlabel('Epochs')
plt.ylabel('Accuracy')
plt.legend()
plt.show()
