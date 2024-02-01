# %Load dataset.py
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder


def get_wine_dataset(path='data/wine.csv', test_size=0.25):
    df = pd.read_csv(path)
    X = df.drop(columns='color')
    y = df['color']
    le = LabelEncoder()
    le.fit(['A', 'B', 'C'])
    X['quality'] = le.transform(X["quality"])
    
    return train_test_split(X, y, test_size=test_size, stratify=y, random_state=0)
    
def get_boston_dataset(path="data/boston_dataset.csv", test_size=0.25):
    df = pd.read_csv(path)
    X = df.drop(columns='MEDV')
    y = df['MEDV']
    return train_test_split(X, y, test_size=test_size, random_state=0)
    
