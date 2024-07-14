import 'package:flutter/material.dart';
import 'package:uprons/auth.dart';
import 'package:uprons/author.dart';
import 'package:uprons/my_books.dart';
import 'package:uprons/user_preferences.dart';
import '../colors.dart';

class SignInEmail extends StatefulWidget {
  const SignInEmail({Key? key}) : super(key: key);

  @override
  State<SignInEmail> createState() => _SignInEmailState();
}

class _SignInEmailState extends State<SignInEmail> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';
  String uidd = '';

  // late final u.User user;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: MyColors.green,
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 170,
            child: Image.asset(
              'assets/Atrons.png',
              width: 140,
              height: 150,
              alignment: Alignment.centerLeft,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                  top: 30, left: 30, right: 30, bottom: 10),
              decoration: BoxDecoration(
                color: MyColors.whiteGreenmod,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const Text(
                              'Log In',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 10),
                            const Text('Welcome to Atrons Author',
                                style: TextStyle(fontSize: 17)),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: email,
                                    cursorColor: Colors.black45,
                                    decoration: const InputDecoration(
                                      focusColor: Colors.teal,
                                      hintText: 'Email',
                                      prefixIcon:
                                          Icon(Icons.email, color: Colors.teal),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.teal, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.teal, width: 2),
                                      ),
                                    ),
                                    validator: (value) =>
                                        value!.isEmpty ? 'Enter email' : null,
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: password,
                                    cursorColor: Colors.black45,
                                    decoration: const InputDecoration(
                                      focusColor: Colors.teal,
                                      hintText: 'Password',
                                      prefixIcon:
                                          Icon(Icons.lock, color: Colors.teal),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.teal, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.teal, width: 2),
                                      ),
                                    ),
                                    obscureText: true,
                                    validator: (value) => value!.length < 6
                                        ? 'Password must be 6+ chars long'
                                        : null,
                                  ),
                                  const SizedBox(height: 10),
                                  // const Row(
                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   children: [
                                  //     Text(
                                  //       'Forgot Password?',
                                  //       style: TextStyle(color: Colors.teal),
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 5),
                                    ),
                                    child: const Text(
                                      'Log In',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => loading = true);
                                        Author? author = await Auth.signIn(
                                            email.text, password.text);
                                        if (author == null) {
                                          setState(() => loading = false);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Incorrect Login Information'),
                                              duration: Duration(seconds: 3),
                                              backgroundColor: Color(0xFF900000),
                                            ),
                                          );
                                        } else {
                                          setState(() => loading = false);
                                          UserPreferences.setUser(author);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (_) => MyBooks(),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    error,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
