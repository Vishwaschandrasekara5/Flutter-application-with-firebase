import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/book.dart';

void main() => runApp(const BookApp());

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book App',
      home: Text('home'),
    );
  }
}

class BookFirebaseDemoState extends StatefulWidget {

  const BookFirebaseDemoState({super.key});

  final String appTitle = 'Book DB';

  @override
  State<BookFirebaseDemoState> createState() => _BookFirebaseDemoStateState();
}

class _BookFirebaseDemoStateState extends State<BookFirebaseDemoState> {

  TextEditingController bookNameController = TextEditingController();
  TextEditingController bookAuthorController = TextEditingController();

  bool isEditing = false;
  bool textFieldVisibility = false;

  String firestoreCollectionName = "Books";
  Book? currentBook;

  Stream<QuerySnapshot> getAllBooks() {
    return FirebaseFirestore.instance.collection(firestoreCollectionName).snapshots();
  }

  Future<void> addBook() async {

    
    Book book = Book(bookName: bookNameController.text, authorName: bookAuthorController.text);

    try{
      await FirebaseFirestore.instance
          .collection(firestoreCollectionName)
          .doc()
          .set(book.toJson());
    }
    catch(e){
      print(e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}