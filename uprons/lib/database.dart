import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uprons/author.dart';
import 'package:uprons/user_preferences.dart';

import 'book.dart';

Stream<List<Book>> getBooks() {
  Author? author = UserPreferences.getUser();

  return FirebaseFirestore.instance
      .collection('Books')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) {
          Map<String, dynamic> data = doc.data();
          if (data['AuthorId'] == author?.authorId) {
            return Book(
              imageUrl: data['Image'],
              bookid: data['BookId'],
              epubUrl: data['EPub'],
              audioUrl: data['Audio'],
              title: data['Title'],
              author: data['Author'],
              description: data['Description'],
              pages: int.parse(data['Pages']),
              price: data['Price'],
              language: data['Language'],
              ratingsReviews: data['RatingsReviews'],
              purchases: data['Purchases'],
              numOfViews: data['NumOfViews'],
              tags: data['Tags'],
              approved: data['approved']
            );
          } else {
            return null;
          }
        })
        .whereType<Book>()
        .toList();
  });
}
