# Import json and stuff from models
import json
from models import app, db, Book

def load_json(filename):
    with open(filename) as file:
        jsn = json.load(file)
        file.close()
    return jsn

# Creating the static info from books.json
def create_books():
    book = load_json('books.json')

    for oneBook in book['Books']:
        title = oneBook['title']
        id = oneBook['id']
        newBook = Book(title = title, id = id)

        #After I create the book, I can then add it to the db
        db.session.add(newBook)
        #commit the session to my db
        db.session.commit()

create_books()
