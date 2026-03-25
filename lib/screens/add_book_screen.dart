import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../services/firestore_service.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final t = TextEditingController();
  final a = TextEditingController();
  final i = TextEditingController();
  final q = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        /// 🎨 BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),

              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(25),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// 📘 ICON
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFF667eea),
                        child: Icon(Icons.book, color: Colors.white),
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Add Book",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Enter book details",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 20),

                      /// TITLE
                      TextField(
                        controller: t,
                        decoration: InputDecoration(
                          labelText: "Title",
                          prefixIcon: const Icon(Icons.title),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// AUTHOR
                      TextField(
                        controller: a,
                        decoration: InputDecoration(
                          labelText: "Author",
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// ISBN
                      TextField(
                        controller: i,
                        decoration: InputDecoration(
                          labelText: "ISBN",
                          prefixIcon: const Icon(Icons.confirmation_number),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// QUANTITY
                      TextField(
                        controller: q,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Quantity",
                          prefixIcon: const Icon(Icons.numbers),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// SAVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFF667eea),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          onPressed: () async {
                            Map<String, dynamic> book = {
                              'title': t.text,
                              'author': a.text,
                              'isbn': i.text,
                              'quantity': int.parse(q.text),
                              'issued': false,
                            };

                            await provider.addBook(book);
                            await FirestoreService().addBook(book);

                            if (!mounted) return;
                            Navigator.pop(context);
                          },

                          child: const Text("Save"),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// BACK BUTTON
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}