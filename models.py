#import Flask, FlaskSQLAlchemy, and os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import os

#Assign the app and configure the database
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get("DB_STRING", 'postgres://postgres:asd123@localhost:5433/bookdb')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True #suppress a warning message
db = SQLAlchemy(app)

# Define all of the models for the database
class Book(db.Model):
    __tablename__ = 'book'

    title = db.Column(db.String(80), nullable = False)
    id = db.Column(db.Integer, primary_key = True)

    @property
    def serialize(self):
        return {'title': self.title, 'id': self.id}



# Create all of the models for the database
db.create_all()
#end of file
