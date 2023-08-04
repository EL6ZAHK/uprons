import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController title;
  late TextEditingController author;
  late TextEditingController description;
  late TextEditingController price;
  late TextEditingController pages;
  late TextEditingController pubYear;
  late TextEditingController tags;

  List<String> languages = ['English', 'Amharic', 'Tigrinya', 'Afaan Oromoo'];
  String language = 'English';
  String tagSplitChar = '*';

  XFile? imagePath;
  String? epubPath, audioPath;
  File? epubFile, audioFile;
  final ImagePicker _picker = ImagePicker();
  String imageName = '';

  bool _isLoading = false;

  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  String collectionName = 'Books'; // create new collection called 'Books'
  String collectionImageName = 'Image';
  String collectionEpubName = 'EPub';
  String collectionAudioName = 'Audio';
  FirebaseStorage storageRef = FirebaseStorage.instance;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    title = TextEditingController();
    author = TextEditingController();
    description = TextEditingController();
    price = TextEditingController();
    pages = TextEditingController();
    pubYear = TextEditingController();
    tags = TextEditingController();
  }

  @override
  void dispose() {
    title.dispose();
    author.dispose();
    description.dispose();
    price.dispose();
    pages.dispose();
    pubYear.dispose();
    tags.dispose();
    super.dispose();
  }

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
                  buildEpubUrl(),
                  const SizedBox(height: 5),
                  _showPdfName(),
                  const SizedBox(height: 20),
                  buildAudioUrl(),
                  const SizedBox(height: 5),
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

  buildEpubUrl() {
    return OutlinedButton(
      onPressed: () async {
        epubPath = await FlutterDocumentPicker.openDocument();
        epubFile = File(epubPath!);
        setState(() {});
      },
      child: Text(
          epubPath == null || epubPath == '' ? 'Select EPub' : 'EPub Selected'),
    );
  }

  buildAudioUrl() {
    return OutlinedButton(
      onPressed: () async {
        audioPath = await FlutterDocumentPicker.openDocument();
        audioFile = File(audioPath!);
        setState(() {});
      },
      child: Text(audioPath == null || audioPath == ''
          ? 'Select Audio'
          : 'Audio Selected'),
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
          child: Text(imageName == '' ? 'Select Image' : 'Image Selected'),
        ),
      ],
    );
  }

  buildTitle() {
    return TextFormField(
      controller: title,
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        return value!.isEmpty ? 'book title required' : null;
      },
    );
  }

  buildAuthor() {
    return TextFormField(
        controller: author,
        decoration: const InputDecoration(
          labelText: 'Author',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          return value!.length < 4 ? 'author name should be > 4' : null;
        });
  }

  buildDescription() {
    return TextFormField(
      controller: description,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: 3,
      decoration: const InputDecoration(
        hintText: 'Short description of the book',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        return value!.length < 10 ? 'book description should be > 10' : null;
      },
    );
  }

  buildPrice() {
    return TextFormField(
      controller: price,
      decoration: const InputDecoration(
        labelText: 'Price',
        hintText: 'Skip if Free',
        border: OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(),
    );
  }

  buildPages() {
    return TextFormField(
      controller: pages,
      decoration: const InputDecoration(
        labelText: 'Pages',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        return value!.length < 1 ? 'number of pages required' : null;
      },
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
      controller: pubYear,
      decoration: const InputDecoration(
        labelText: 'Publication Year',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.datetime,
      validator: (value) {
        return value!.length < 1 ? 'publication year required' : null;
      },
    );
  }

  buildTags() {
    return TextFormField(
      controller: tags,
      decoration: InputDecoration(
        labelText: 'Tags',
        hintText:
            'Keywords${tagSplitChar}splitted${tagSplitChar}by${tagSplitChar}"${tagSplitChar}"',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        return value!.length < 1 ? 'tags required' : null;
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
            String forFileName =
                DateTime.now().millisecondsSinceEpoch.toString();
            String uploadFileName = forFileName + '.jpg';
            Reference reference = storageRef
                .ref()
                .child(collectionImageName)
                .child(uploadFileName);
            UploadTask uploadTask = reference.putFile(File(imagePath!.path));

            String uploadAudioFileName = forFileName + '.mp3';
            reference = storageRef
                .ref()
                .child(collectionAudioName)
                .child(uploadAudioFileName);
            UploadTask audiotask = reference.putFile(audioFile!.path as File);

            String uploadEpubFileName = forFileName + '.epub';
            reference = storageRef
                .ref()
                .child(collectionEpubName)
                .child(uploadEpubFileName);
            UploadTask task = reference.putFile(epubFile!);

            await task.whenComplete(() async {
              var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
              var epubPath = await task.snapshot.ref.getDownloadURL();
              var audioPath = await audiotask.snapshot.ref.getDownloadURL();

              if (uploadPath.isNotEmpty && epubPath.isNotEmpty) {
                firestoreRef.collection(collectionName).doc(uniqueKey.id).set({
                  "BookId": uniqueKey.id,
                  "EPub": epubPath,
                  "Audio": audioPath,
                  "Image": uploadPath,
                  "Title": title.text,
                  "Author": author.text,
                  "Description": description.text,
                  "Price": price.text,
                  "Pages": pages.text,
                  "Purchases": 0,
                  "RatingsReviews": [],
                  "Language": language,
                  "PubYear": pubYear.text,
                  "Tags": tags.text.split(tagSplitChar),
                }).then((value) => _showMessage("Record Inserted."));
              } else if (uploadPath.isNotEmpty && audioPath.isNotEmpty) {
                firestoreRef.collection(collectionName).doc(uniqueKey.id).set({
                  "BookId": uniqueKey.id,
                  // "EPub": epubPath,
                  "Audio": audioPath,
                  "Image": uploadPath,
                  "Title": title.text,
                  "Author": author.text,
                  "Description": description.text,
                  "Price": price.text,
                  "Pages": pages.text,
                  "Purchases": 0,
                  "RatingsReviews": [],
                  "Language": language,
                  "PubYear": pubYear.text,
                  "Tags": tags.text.split(tagSplitChar),
                }).then((value) => _showMessage("Record Inserted."));
              } else {
                _showMessage("Something while Uploading image");
              }
              setState(() {
                _isLoading = false;
                epubPath = '';
                imageName = '';
                title.text = '';
                author.text = '';
                description.text = '';
                price.text = '';
                pages.text = '';
                pubYear.text = '';
                tags.text = '';
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

  _showPdfName() {
    return epubPath == '' || epubPath == null
        ? Container()
        : Column(
            children: [
              const Text('Selected EPub File 👇'),
              const SizedBox(height: 3),
              Text(
                epubPath!,
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
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
