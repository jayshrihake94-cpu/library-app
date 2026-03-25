import 'package:flutter/material.dart';
import '../providers/book_provider.dart';

class EditBookScreen extends StatefulWidget {
  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final t = TextEditingController();
  final a = TextEditingController();
  final i = TextEditingController();
  final q = TextEditingController();

  BookProvider provider = BookProvider();
  int index = 0;
  bool issued = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var data = ModalRoute.of(context)!.settings.arguments as Map;

    index = data['index'];
    var b = data['book'];

    t.text = b['title'];
    a.text = b['author'];
    i.text = b['isbn'];
    q.text = b['quantity'].toString();

    issued = b['issued'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Book")),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: t, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: a, decoration: InputDecoration(labelText: "Author")),
            TextField(controller: i, decoration: InputDecoration(labelText: "ISBN")),
            TextField(controller: q, decoration: InputDecoration(labelText: "Quantity")),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await provider.updateBook(index, {
                  'title': t.text,
                  'author': a.text,
                  'isbn': i.text,
                  'quantity': int.parse(q.text),
                  'issued': issued, // ✅ IMPORTANT
                });

                Navigator.pop(context);
              },
              child: Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}