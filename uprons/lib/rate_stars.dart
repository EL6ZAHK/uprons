import 'package:flutter/material.dart';

class RateStars extends StatelessWidget {
  const RateStars({Key? key, required this.rate}) : super(key: key);
  final double rate;

  @override
  Widget build(BuildContext context) {
    if (rate > 4) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
        ],
      );
    }
    if (rate > 3) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.grey, size: 16),
        ],
      );
    }
    if (rate > 2) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.grey, size: 16),
          Icon(Icons.star_rate, color: Colors.grey, size: 16),
        ],
      );
    }
    if (rate > 1) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.grey, size: 16),
          Icon(Icons.star_rate, color: Colors.grey, size: 16),
          Icon(Icons.star_rate, color: Colors.grey, size: 16),
        ],
      );
    }
    if (rate > 0) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rate, color: Colors.teal, size: 16),
          Icon(Icons.star_rate, color: Colors.grey, size: 16),
          Icon(Icons.star_rate, color: Colors.grey, size: 16),
          Icon(Icons.star_rate, color: Colors.grey, size: 16),
          Icon(Icons.star_rate, color: Colors.grey, size: 16),
        ],
      );
    } else {
      return const Row();
    }
  }
}