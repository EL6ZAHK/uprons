
import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uprons/author.dart';

class Auth {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Author?> signIn(String email, String password) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Authors').get();

      List<QueryDocumentSnapshot> docs = querySnapshot.docs;

      for (var doc in docs) {
        final hashedPassword = doc['password'];

        if (doc['email'] == email && BCrypt.checkpw(password, hashedPassword)) {
          Author author = new Author(authorId: doc['AuthorId'], address: doc['address'], contact: doc['contact'], email: email, firstName: doc['firstName'], lastName: doc['lastName'], numOfBooks: doc['numOfBooks'], password: password);
          return author;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
