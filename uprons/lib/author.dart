class Author {
  Author(
      {required this.authorId,
      required this.address,
      required this.contact,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.numOfBooks,
      required this.password});

  final String authorId;
  final String address;
  final String contact;
  final String email;
  final String firstName;
  final String lastName;
  final int numOfBooks;
  final String password;

  get isDarkMode => null;

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'address': address,
      'contact': contact,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'numOfBooks': numOfBooks,
      'password': password
    };
  }

  static Author fromJson(Map<String, dynamic> json) {
    return Author(
        authorId: json['authorId'],
        address: json['address'],
        contact: json['contact'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        numOfBooks: json['numOfBooks'],
        password: json['password']);
  }
}
