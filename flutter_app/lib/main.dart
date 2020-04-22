import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(App());
}

class BookInfo {
  final String title;
  final int id;

  BookInfo({this.title, this.id});

  factory BookInfo.fromJson(Map<String, dynamic> json) {
    return BookInfo(title: json['title'], id: json['id']);
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
      home: MyHomePage(title: 'Book Database Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<BookInfo>> _fetchBooks() async {
    //final booksListAPIUrl = 'http://10.0.2.2:5000/books';
    final booksListAPIUrl = 'http://127.0.0.1:5000/books';
    print(booksListAPIUrl);
    final response = await http.get(booksListAPIUrl);
    print(response);

    if (response.statusCode == 200) {
      print('good response');
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((book) => new BookInfo.fromJson(book)).toList();
    } else {
      print('bad response');
      throw Exception('Failed to load books from API');
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<BookInfo>>(
      future: _fetchBooks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<BookInfo> data = snapshot.data;
          return _bookListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  ListView _bookListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].title, data[index].id, Icons.flag);
        });
  }

  ListTile _tile(String title, int id, IconData icon) => ListTile(
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.black)),
        subtitle: Text('Book id: ' + id.toString()),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
      );
}
