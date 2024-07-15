import 'package:flutter/material.dart';
import 'package:uprons/book_desc.dart';
import 'package:uprons/books_analysis.dart';
import 'package:uprons/homepage.dart';
import 'package:uprons/login.dart';
import 'package:uprons/user_preferences.dart';
import 'book.dart';
import 'database.dart';

class MyBooks extends StatefulWidget {
  const MyBooks({Key? key}) : super(key: key);

  @override
  State<MyBooks> createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  late List<Book> books;

  @override
  void initState() {
    super.initState();
    books = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.logout_outlined),
              iconSize: 26,
              onPressed: () async {
                await UserPreferences.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SignInEmail()));
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_to_photos_rounded),
                iconSize: 26,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => HomePage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.analytics_outlined),
                iconSize: 26,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BooksAnalysis(books: books),
                    ),
                  );
                },
              ),
            ],
            expandedHeight: 100.0,
            pinned: true,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text('My Books'),
            ),
          ),
          StreamBuilder<List<Book>>(
            stream:
                getBooks(), // Assuming getBooks() returns a Stream<List<Book>>
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('Something went wrong: ${snapshot.error}'),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverToBoxAdapter(
                    child: Center(
                  child: Text('No books available'),
                ));
              } else {
                books = snapshot.data!;
                return SliverGrid.count(
                  crossAxisCount: 3,
                  childAspectRatio: 0.60,
                  children: List.generate(books.length, (index) {
                    final book = books[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookDesc(book: book),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'tag-${book.bookid}', // Ensure a unique tag
                              child: Image.network(
                                book.imageUrl,
                                width: 110,
                                height: 133,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.broken_image,
                                    size: 110,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),
                          ),
                          Text(
                            'By ${book.author.length < 21 ? book.author : '${book.author.substring(0, 19)}..'}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
