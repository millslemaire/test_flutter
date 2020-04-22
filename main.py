# run with $ python3 main.py
from flask import render_template, jsonify
from create_db import app, db, Book, create_books

# A route to return all of the available entries in our catalog.
@app.route('/api/books', methods=['GET'])
def api_books():
    response = []
    books = db.session.query(Book).all()
    for book in books:
        response.append(book.serialize)
    return jsonify(response)

if __name__ == "__main__":
    app.run()
