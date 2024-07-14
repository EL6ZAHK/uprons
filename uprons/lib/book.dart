import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  Book({
    required this.imageUrl,
    required this.epubUrl,
    this.audioUrl,
    required this.title,
    required this.author,
    this.language,
    this.price = 'Free',
    required this.description,
    required this.pages,
    this.pagesRead = 0,
    this.publicationYear,
    required this.tags,
    required this.bookid,
    required this.ratingsReviews,
    required this.purchases,
    required this.numOfViews,
    required this.approved
  });

  final String imageUrl;
  final String epubUrl;
  final String? audioUrl;
  final String title;
  final String author;
  final String? language;
  final String price;
  final String description;
  late int pagesRead;
  final int pages;
  final int? publicationYear;
  final List tags;
  final String bookid;
  final int purchases;
  final int numOfViews;
  final bool approved;

  List ratingsReviews; // [{'userid': '', 'rating': 0.0, 'review': ''}]

  late int peopleRated = ratingsReviews.length;

  set setPagesRead(int p) {
    pagesRead = p;
  }

//    bool markedb() {
//     User? localuser;
//     List<String> marked = <String>[];
// //  FirebaseFirestore.instance
// //         .collection('Users')
// //         .doc(localuser!.userID)
// //         .collection('bookmark');

//     FirebaseFirestore.instance
//         .collection('Users')
//         .doc(localuser!.userID)
//         .collection('bookmark')
//         .get()
//         .then((QuerySnapshot? QuerySnapshot) {
//       print("hiiiiiiiiiii");
//       QuerySnapshot!.docs.forEach((doc) {
//         marked = doc[''];
//         print("Helloooo = $marked");
//       });
//     });
//     if (bookMarked != null) {
//       return bookMarked = true;
//     } else {
//       return bookMarked = false;
//     }



//   }

  int getPercentRead() {
    return ((pagesRead / pages) * 100).round();
  }

  void setRating(Map<String, dynamic> newReview) {
    final json = jsonEncode(newReview);
    final rateReviewRef =
        FirebaseFirestore.instance.collection('Books').doc(bookid);
    rateReviewRef.update({
      'RatingsReviews': FieldValue.arrayUnion([json])
    });
  }

  void deleteRating(Map<String, dynamic> unwantedReview) {
    final json = jsonEncode(unwantedReview);
    final rateReviewRef =
        FirebaseFirestore.instance.collection('Books').doc(bookid);
    rateReviewRef.update({
      'RatingsReviews': FieldValue.arrayRemove([json])
    });
  }

  String getRating() {
    if (ratingsReviews.isEmpty) {
      return "0.0";
    }
    
    double sum = 0;
    double rate;
    for (final rateReview in ratingsReviews) {
      final data = jsonDecode(rateReview);
      sum += data['rating'];
    }
    rate = sum / ratingsReviews.length;
    return rate.toStringAsFixed(1);
  }

  void addPurchase() async {
    final purchaseRef =
        FirebaseFirestore.instance.collection('Books').doc(bookid);
    purchaseRef.update({'Purchases': FieldValue.increment(1)});
  }

  void addNumOfView() async {
    final viewRef = FirebaseFirestore.instance.collection("Books").doc(bookid);
    viewRef.update({'NumOfViews': FieldValue.increment(1)});
  }

  bool areReviews() {
    for (final rateReview in ratingsReviews) {
      final data = jsonDecode(rateReview);
      if (data['review'].toString().isNotEmpty &&
          data['review'].toString() != '') {
        return true;
      }
    }
    return false;
  }
}
