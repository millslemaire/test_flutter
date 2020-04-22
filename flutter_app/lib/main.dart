import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(App());
}

//Model of a Book
class Book {
  final int id;
  final String title;

  Book({this.id, this.title});

  factory Book.fromJson(Map<String, dynamic> json) {
    return new Book(id: json['id'], title: json['title']);
  }
}

//Model of a Book List
class BooksList {
  final List<Book> books;
  BooksList({this.books});

  factory BooksList.fromJson(List<dynamic> parsedJson) {
    List<Book> books = new List<Book>();
    books = parsedJson.map((i) => Book.fromJson(i)).toList();
    return new BooksList(books: books);
  }
}

//Function to fetch a Book List
Future<BooksList> fetchBooksList() async {
  //final booksListAPIUrl = 'http://10.0.2.2:5000/api/books';
  final booksListAPIUrl = 'http://127.0.0.1:5000/api/books';
  print(booksListAPIUrl);
  final response = await http.get(booksListAPIUrl);
  print(response);

  if (response.statusCode == 200) {
    print('good response');
    return BooksList.fromJson(json.decode(response.body));
  } else {
    print('bad response');
    throw Exception('Failed to load post');
  }
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Database Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Database Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<BooksList>(
            future: fetchBooksList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                for (var i = 0; i < snapshot.data.books.length; i++) {
                  return Text(snapshot.data.books[i].title +
                      " - " +
                      snapshot.data.books[i].id.toString());
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
