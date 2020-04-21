# run with $ python3 main.py
from flask import render_template
from create_db import app, db, Book, create_books

# A route to return all of the available entries in our catalog.
@app.route('/api/v1/resources/books/all', methods=['GET'])
def api_all():
    books = db.session.query(Book).all()
    return jsonify(books)

if __name__ == "__main__":
    app.run()
