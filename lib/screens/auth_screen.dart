import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:raven/widgets/user_image_picker.dart';

import 'dart:io';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;

  String _email = '';
  String _password = '';
  String _username = '';
  File? _uplodedImage;

  void _saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        setState(() {
          _isLoading = true;
        });
        if (_isLogin) {
          final userCredentials = await _firebase.signInWithEmailAndPassword(
              email: _email, password: _password);
          print(userCredentials);
        } else if (_uplodedImage != null) {
          final userCredentials =
              await _firebase.createUserWithEmailAndPassword(
                  email: _email, password: _password);

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_dps')
              .child('${userCredentials.user!.uid}.jpg');

          await storageRef.putFile(_uplodedImage!);
          final dpURL = await storageRef.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredentials.user!.uid)
              .set({
            'username': _username,
            'email': _email,
            'imageURL': dpURL,
          });
        }
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? "Authentication Failed")));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 2,
            shadowColor: Colors.black,
            surfaceTintColor: Colors.black,
            margin: const EdgeInsets.all(10),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Image.asset(
                        'assets/images/raven.png',
                        width: 80,
                      ),
                    ),
                    Text(
                      _isLogin ? 'Welcome Back !' : 'Welcome !',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (!_isLogin)
                      UserImagePicker(
                        onUploadImage: (image) {
                          _uplodedImage = image;
                        },
                      ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        label: Text("Email address"),
                        icon: Icon(
                          Icons.account_box_rounded,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains("@")) {
                          return "Please Enter a valid email address";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(
                          Icons.key,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.length < 6) {
                          return "Password should 6 characters long";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Username',
                          icon: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.length < 4) {
                            return "Username should be 4 letters long";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!;
                        },
                      ),
                    const SizedBox(
                      height: 30,
                    ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(300, 6),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.background),
                            onPressed: () {
                              _saveForm();
                            },
                            child: Text(
                                _isLogin ? 'Log in' : 'Create an Account '),
                          ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                            _isLogin ? 'Create an Account' : 'Log In Instead'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
