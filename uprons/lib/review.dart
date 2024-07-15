import 'package:flutter/material.dart';
import 'package:uprons/rate_stars.dart';

class Review extends StatelessWidget {
  const Review({
    Key? key,
    required this.image,
    required this.username,
    required this.rate,
    required this.review,
  }) : super(key: key);

  final ImageProvider image;
  final String username;
  final double rate;
  final String review;

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: image,
                  radius: 20,
                ),
                const SizedBox(width: 20),
                Text(
                  username,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(width: 190, child: RateStars(rate: rate)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 50),
            Container(
              width: (phoneWidth / 2) + 70,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(77, 128, 127, 127),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(review),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
