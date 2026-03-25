import 'package:flutter/material.dart';
import '../providers/book_provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  BookProvider provider = BookProvider();
  List books = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  loadBooks() async {
    books = await provider.getBooks();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Library Management"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
              ? const Center(child: Text("No Books Available"))
              : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    var b = books[index];
                    bool issued = b['issued'] ?? false;

                    return Card(
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(15),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              b['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),
                            Text("Author: ${b['author']}"),
                            Text("ISBN: ${b['isbn']}"),
                            Text("Qty: ${b['quantity']}"),

                            const SizedBox(height: 8),

                            Text(
                              issued ? "Book Issued ❌" : "Available ✅",
                              style: TextStyle(
                                color: issued ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await provider.toggleIssue(index);
                                    loadBooks();
                                  },
                                  icon: const Icon(Icons.swap_horiz),
                                  label: const Text("Issue"),
                                ),

                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/editBook',
                                      arguments: {
                                        'index': index,
                                        'book': b
                                      },
                                    ).then((_) => loadBooks());
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: const Text("Edit"),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                ),

                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await provider.deleteBook(index);
                                    loadBooks();
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: const Text("Delete"),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF667eea),
        onPressed: () {
          Navigator.pushNamed(context, '/addBook')
              .then((_) => loadBooks());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}