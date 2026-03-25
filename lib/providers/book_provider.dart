import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class BookProvider extends ChangeNotifier {

  Future<List> getBooks() async {
    return await LocalStorageService.getData('books') ?? [];
  }

  Future addBook(Map book) async {
    List books = await getBooks();
    books.add(book);
    await LocalStorageService.saveData('books', books);
    notifyListeners();
  }

  Future deleteBook(int index) async {
    List books = await getBooks();
    books.removeAt(index);
    await LocalStorageService.saveData('books', books);
    notifyListeners();
  }

  Future updateBook(int index, Map updatedBook) async {
    List books = await getBooks();

    updatedBook['issued'] = books[index]['issued'] ?? false;

    books[index] = updatedBook;
    await LocalStorageService.saveData('books', books);
    notifyListeners();
  }

  Future toggleIssue(int index) async {
    List books = await getBooks();

    bool current = books[index]['issued'] ?? false;
    books[index]['issued'] = !current;

    await LocalStorageService.saveData('books', books);
    notifyListeners();
  }
}