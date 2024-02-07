
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.datasets import load_breast_cancer

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
    

def get_breast_cancer_dataset(test_size=0.25, scaling=False):
    data = load_breast_cancer()
    X, y = data.data, data.target
    X_train, X_test, y_train, y_test = train_test_split(X, y,
                                                        test_size=test_size,
                                                        stratify=y,
                                                        random_state=0)
    if scaling:
        scaler = StandardScaler()
        X_train = scaler.fit_transform(X_train)
        X_test = scaler.transform(X_test)
    
    return (X_train, X_test, y_train, y_test), data.feature_names
    
