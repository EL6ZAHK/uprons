import 'package:flutter/material.dart';
import 'package:uprons/book.dart';

class BookDesc extends StatefulWidget {
  const BookDesc({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  State<BookDesc> createState() => _BookDescState();
}

class _BookDescState extends State<BookDesc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0.0,
            // leading: IconButton(
            //   icon: const Icon(Icons.logout_outlined),
            //   iconSize: 26,
            //   onPressed: () async {
            //     await UserPreferences.signOut();
            //     Navigator.of(context).pushReplacement(
            //         MaterialPageRoute(builder: (_) => SignInEmail()));
            //   },
            // ),
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.add_to_photos_rounded),
            //     iconSize: 26,
            //     onPressed: () {
            //       Navigator.of(context)
            //           .push(MaterialPageRoute(builder: (_) => HomePage()));
            //     },
            //   ),
            // ],
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
            child: Image.network(
              widget.book.imageUrl,
              width: 200,
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
          )),
        ],
      ),
    );
  }
}
