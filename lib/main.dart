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
      debugPrint(e.toString());
    }
  }

  Future<void> updateBook(
  Book book,
  String bookName,
  String authorName,
) async {
  try {
    await FirebaseFirestore.instance
        .collection(firestoreCollectionName)
        .doc(book.documentReference!.id)
        .update({
          'bookName': bookName,
          'authorName': authorName,
        });
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> updateIfEditing() async {
  if (isEditing) {
    await updateBook(
      currentBook!,
      bookNameController.text,
      bookAuthorController.text,
    );
  } else {
    await addBook();
  }

  setState(() {
    isEditing = false;
    textFieldVisibility = false;
  });
}


  Future<void> deleteBook(Book book) async {
    try {
      await FirebaseFirestore.instance
          .collection(firestoreCollectionName)
          .doc(book.documentReference!.id)
          .delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }



Widget buildbody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: getAllBooks(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (snapshot.hasData) {
        debugPrint(
            "Data received: ${snapshot.data!.docs.length} books");
        return buildList(context, snapshot.data!.docs);
      }

      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}


Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => listItemBuild(context, data)).toList(),
    );
  }

  Widget listItemBuild(BuildContext context, DocumentSnapshot data) {
    final book = Book.fromSnapshot(data);

    return Padding(
      key: ValueKey(book.bookName),
      padding: EdgeInsets.symmetric(vertical: 19, horizontal: 1),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(4),
          ),
          child: SingleChildScrollView(
            child: ListTile(
              title: Column(
                children: <Widget>[
                  Row(
                    children:<Widget>[
                      Icon(Icons.book, color: Colors.blueAccent),
                      Text(book.bookName ?? 'Unknown Book')
                    ]
                  ),
                  Divider(),
                  Row(
                    children:<Widget>[
                      Icon(Icons.person, color: Colors.blueAccent),
                      Text(book.authorName ?? 'Unknown Author')
                    ]
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon (Icons.delete, color: Colors.redAccent),
                onPressed: (){
                  deleteBook(book);
                },

            ),
            onTap: (){
              setUpdateUI(book);
            }
          )
      ),
    ),
    );
  }


void setUpdateUI(Book book) {
    bookNameController.text = book.bookName ?? '';
    bookAuthorController.text = book.authorName ?? '';

    setState(() {
      isEditing = true;
      textFieldVisibility = true;
      currentBook = book;
    });
}

Widget button(){

  return SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: () {
        if(isEditing == true){
          updateIfEditing();
        }
        else{
          addBook();
        }

        setState(() {
          textFieldVisibility = false;
        });
        
      },
      child: Text(isEditing ? 'Update Book' : 'Add Book'),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}