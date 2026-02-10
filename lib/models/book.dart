import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String? bookName;
  final String? authorName;

  final DocumentReference? documentReference;

  Book({this.bookName, this.authorName, this.documentReference});

  Book.fromMap(Map<String, dynamic> map, {this.documentReference})
      : bookName = map['bookName'],
        authorName = map['authorName'];

  Book.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            documentReference: snapshot.reference);

  Map<String, dynamic> toJson() {
    return {
      'bookName': bookName,
      'authorName': authorName,
      'documentReference': documentReference,
    };
  }
}