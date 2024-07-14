import 'package:flutter/material.dart';
import 'package:uprons/skeleton.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Skeleton(height: 25, width: 25, radius: 7),
                  const Skeleton(height: 25, width: 200, radius: 10),
                  const Skeleton(height: 25, width: 25, radius: 7)
                ],
              ),
              const SizedBox(height: 20),
              const Skeleton(height: 150, width: 240, radius: 10),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(width: 5),
                  Skeleton(height: 30, width: 80, radius: 8),
                  SizedBox(width: 20),
                  Skeleton(height: 30, width: 80, radius: 8),
                  SizedBox(width: 20),
                  Skeleton(height: 30, width: 80, radius: 8),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Skeleton(
                          height: 160,
                          width: 120,
                          radius: 10,
                        ),
                        SizedBox(height: 5),
                        Skeleton(height: 10, width: 120, radius: 8)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Skeleton(
                          height: 160,
                          width: 120,
                          radius: 10,
                        ),
                        SizedBox(height: 5),
                        Skeleton(height: 10, width: 120, radius: 8)
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Skeleton(
                          height: 160,
                          width: 120,
                          radius: 10,
                        ),
                        SizedBox(height: 5),
                        Skeleton(height: 10, width: 120, radius: 8)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Skeleton(
                          height: 160,
                          width: 120,
                          radius: 10,
                        ),
                        SizedBox(height: 5),
                        Skeleton(height: 10, width: 120, radius: 8)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
