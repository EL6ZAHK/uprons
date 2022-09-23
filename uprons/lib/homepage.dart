import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = '';
  String author = '';
  String description = '';
  String price =
      ''; // when uploading price if price is 0 or empty the value will be 'Free'
  String pagesStr = ''; // you can convert from string to int
  String language = 'English';
  String pubYear = ''; // dd/mm/yyyy
  List<String> tags = []; // keywords for the book eg. its genre, ...
  List<String> languages = ['English', 'Amharic', 'Tigrigna', 'Afaan Oromoo'];

  XFile? imagePath;
  final ImagePicker _picker = ImagePicker();
  String imageName = '';

  bool _isLoading = false;

  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  String collectionName = 'Books'; // create new collection called 'Books'
  String collectionImageName = 'Image'; // create new collection called 'Books'
  FirebaseStorage storageRef = FirebaseStorage.instance;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UpAtrons'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  buildImageUrl(),
                  const SizedBox(height: 5),
                  _showImageName(),
                  const SizedBox(height: 20),
                  buildTitle(),
                  const SizedBox(height: 20),
                  buildAuthor(),
                  const SizedBox(height: 20),
                  buildDescription(),
                  const SizedBox(height: 20),
                  buildPrice(),
                  const SizedBox(height: 20),
                  buildPages(),
                  const SizedBox(height: 20),
                  buildLanguage(),
                  const SizedBox(height: 20),
                  buildPubYear(),
                  const SizedBox(height: 20),
                  buildTags(),
                  const SizedBox(height: 20),
                  buildSubmit(),
                ],
              ),
            ),
    );
  }

  buildImageUrl() {
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(),
          ),
          child: imagePath == null
              ? const Center(child: Text('No image selected'))
              : Image.file(File(imagePath!.path)),
        ),
        OutlinedButton(
          onPressed: () async {
            final XFile? image =
                await _picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                imagePath = image;
                imageName = image.name.toString();
              });
            }
          },
          child: const Text('Select Image'),
        ),
      ],
    );
  }

  buildTitle() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) => setState(() => title = value),
      validator: (value) {
        return value!.isEmpty ? 'book title required' : null;
      },
    );
  }

  buildAuthor() {
    return TextFormField(
        decoration: const InputDecoration(
          labelText: 'Author',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => setState(() => author = value),
        validator: (value) {
          return value!.length < 4 ? 'author name should be > 4' : null;
        });
  }

  buildDescription() {
    return TextFormField(
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: 3,
      decoration: const InputDecoration(
        hintText: 'Short description of the book',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) => setState(() => description = value),
      validator: (value) {
        return value!.length < 10 ? 'book description should be > 10' : null;
      },
    );
  }

  buildPrice() {
    return TextFormField(
      initialValue: price,
      decoration: const InputDecoration(
        labelText: 'Price',
        border: OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(),
      onChanged: (value) =>
          setState(() => value == '0' ? price = 'Free' : price = value),
    );
  }

  buildPages() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Pages',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) => setState(() => pagesStr = value),
    );
  }

  buildLanguage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          items: languages.map((item) {
            return DropdownMenuItem(child: Text(item), value: item);
          }).toList(),
          value: language,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down_rounded),
          iconSize: 25,
          hint: const Text('Language'),
          onChanged: (value) {
            setState(() => language = value.toString());
          },
        ),
      ),
    );
  }

  buildPubYear() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Publication Year',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.datetime,
      onChanged: (value) => setState(() => pubYear = value),
    );
  }

  buildTags() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Tags',
        hintText: 'Keywords with space',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        tags = value.split(' ');
      },
    );
  }

  buildSubmit() {
    return ElevatedButton(
        child: const Text('Upload'),
        onPressed: () async {
          final formIsValid = formKey.currentState!.validate();

          if (formIsValid) {
            setState(() => _isLoading = true);

            var uniqueKey = firestoreRef.collection(collectionImageName).doc();
            String uploadFileName =
                DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
            Reference reference = storageRef
                .ref()
                .child(collectionImageName)
                .child(uploadFileName);
            UploadTask uploadTask = reference.putFile(File(imagePath!.path));
            uploadTask.snapshotEvents.listen((event) {
              print(event.bytesTransferred.toString() +
                  "\t" +
                  event.totalBytes.toString());
            });

            await uploadTask.whenComplete(() async {
              var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();

              if (uploadPath.isNotEmpty) {
                firestoreRef.collection(collectionName).doc(uniqueKey.id).set({
                  "Image": uploadPath,
                  "Title": title,
                  "Author": author,
                  "Description": description,
                  "Price": price,
                  "Pages": pagesStr,
                  "Language": language,
                  "PubYear": pubYear,
                  "Tags": tags
                }).then((value) => _showMessage("Record Inserted."));
              } else {
                _showMessage("Something while Uploading image");
              }
              setState(() {
                _isLoading = false;
                description = '';
                imageName = '';
                price = '';
              });
            });
          }
        });
  }

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    ));
  }

  _showImageName() {
    return imageName == ''
        ? Container()
        : Column(
            children: [
              const Text('Selected Image 👇'),
              const SizedBox(height: 3),
              Text(
                imageName,
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
  }
}
