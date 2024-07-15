import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uprons/book.dart';
import 'package:uprons/review.dart';
import 'package:uprons/user_preferences.dart';

import 'author.dart';

class BookDesc extends StatefulWidget {
  const BookDesc({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  State<BookDesc> createState() => _BookDescState();
}

class _BookDescState extends State<BookDesc> {
  List<Map<String, dynamic>> myReviews = [];

  @override
  void initState() {
    super.initState();
    for (final ratingreview in widget.book.ratingsReviews) {
      final ratedata = jsonDecode(ratingreview);

      getUserImageAndName(ratedata['userid']).then((value) {
        myReviews.add({
          'name': value['name'],
          'image': value['image'],
          'rating': ratedata['rating'],
          'review': ratedata['review']
        });
      });
    }
  }

  Future<Map<String, String>> getUserImageAndName(String userid) async {
    String image = 'assets/images/noprofile.png';
    String username = 'Someone';
    final docRef = FirebaseFirestore.instance.collection('Users').doc(userid);

    await docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        image = data['Image'];
        username = data['Full Name'];
      },
    );
    return {'image': image, 'name': username};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0.0,
            expandedHeight: 100.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.book.title),
                  ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                children: [
                  Container(
                    color: widget.book.approved
                        ? Colors.green[900]
                        : Colors.red[800],
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    child: Text(
                      widget.book.approved ? 'Approved' : 'Pending',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Image.network(
                          widget.book.imageUrl,
                          width: 160,
                          height: 223,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              size: 110,
                              color: Colors.grey,
                            );
                          },
                        ),
                        Text(
                          'Author: ${widget.book.author}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Price: ETB ${widget.book.price}'),
                            Text(
                              'Purchases: ${widget.book.purchases}',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text('Pages: ${widget.book.pages}'),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text('Language: ${widget.book.language}'),
                        Text(
                            'Publication Year: ${widget.book.publicationYear}'),
                        Text('Views: ${widget.book.numOfViews}'),
                        SizedBox(height: 10),
                        Text(
                          widget.book.description,
                          style: TextStyle(height: 2),
                        ),
                        SizedBox(height: 10),
                        widget.book.tags.length > 0
                            ? Text('Tags:',
                                style: TextStyle(fontWeight: FontWeight.bold))
                            : Container(),
                        ...widget.book.tags.map((tag) => Text(tag)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star),
                            Text(widget.book.getRating()),
                          ],
                        ),
                        SizedBox(height: 20),
                        myReviews.length > 0
                            ? Text(
                                'Reviews',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Container(),
                        ...myReviews.map((ratingReview) {
                          if (ratingReview['review'] == '') {
                            return Container();
                          }

                          final imagePath = ratingReview['image'];
                          final usernamePath = ratingReview['name'];

                          ImageProvider image;

                          if (imagePath.contains('https://')) {
                            image = NetworkImage(imagePath);
                          } else if (imagePath.contains('assets')) {
                            image = AssetImage(imagePath);
                          } else {
                            image = FileImage(File(imagePath));
                          }

                          return Review(
                            image: image,
                            username: usernamePath,
                            rate: ratingReview['rating'].toDouble(),
                            review: ratingReview['review'],
                          );
                        }).toList(),
                        ElevatedButton(
                          child: Text('Remove Book'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red[800],
                          ),
                          onPressed: () async {
                            try {
                              Author? author = UserPreferences.getUser();
                              await FirebaseFirestore.instance
                                  .collection('Books')
                                  .doc(widget.book.bookid)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection('Authors')
                                  .doc(author?.authorId)
                                  .update(
                                      {'NumOfBooks': FieldValue.increment(-1)});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${widget.book.title} removed successfully',
                                  ),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.teal,
                                ),
                              );
                              Navigator.of(context).pop();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Couldn\'t Remove Book Try Again'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red[800],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
