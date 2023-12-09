import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import '../widget/picker/image_picker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _firebase = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = '';
  String username = '';
  String password = '';
  bool isLogin = true;
  bool visibility = true;
  File? selectedImage;
  bool isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SVG Section

              Container(
                height: 200,
                margin: const EdgeInsets.all(16),
                child: SvgPicture.asset(
                  'assets/img/signup.svg',
                  fit: BoxFit.fill,
                ),
              ),

              // Form Section

              Card(
                elevation: 8,
                margin: const EdgeInsets.all(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: isLogin ? 320 : 470,
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // header section
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14.0),
                            child: Text(
                              isLogin ? 'Login' : 'Sign Up',
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                              //textAlign: TextAlign.start,
                            ),
                          ),

                          // Pick User Image Section
                          if (!isLogin)
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 400),
                              opacity: isLogin ? 0 : 1,
                              curve: Curves.easeInOut,
                              child: PickImg(
                                onPickedImage: (File pickedImage) {
                                  selectedImage = pickedImage;
                                },
                              ),
                            ),

                          const SizedBox(
                            height: 12,
                          ),

                          // user name
                          if (!isLogin)
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 400),
                              opacity: isLogin ? 0 : 1,
                              curve: Curves.easeInOut,
                              child: TextFormField(
                                key: const ValueKey('username'),
                                enabled: !isLogin,
                                validator: !isLogin? (String? val) {
                                  if (val!.isEmpty || val.trim().length < 4) {
                                    return 'User is to short Please enter at least 6 char';
                                  }
                                  return null;
                                } : null,

                                  onSaved: !isLogin? (newVal) {
                                  setState(() {
                                    username = newVal!;
                                  });
                                } : null,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(height: 1),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xff0091FF),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.red[900]!,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.red[900]!,
                                    ),
                                  ),
                                  labelText: 'User Name',
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                           SizedBox(
                            height: isLogin? 0 : 8,
                          ),

                          // E-mail text field
                          TextFormField(
                            key: const ValueKey('email'),
                            validator: (String? val) {
                              if (val!.isEmpty || !val.contains('@')) {
                                return 'Please Enter valid Email';
                              }
                              return null;
                            },
                            onSaved: (newVal) {
                              setState(() {
                                email = newVal!;
                              });
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(height: 1),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xff0091FF),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.red[900]!,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.red[900]!,
                                ),
                              ),
                              prefixIcon: const Icon(Icons.email_outlined,
                                  color: Colors.grey),
                              labelText: 'E-Mail',
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          // Password text field
                          TextFormField(
                            key: const ValueKey('password'),
                            validator: (String? val) {
                              if (val!.isEmpty || val.length < 4) {
                                return 'User is to short Please enter at least 6 char';
                              }
                              return null;
                            },
                            onSaved: (newVal) {
                              setState(() {
                                password = newVal!;
                              });
                            },
                            obscureText: visibility,
                            keyboardType: TextInputType.visiblePassword,
                            style: const TextStyle(height: 1),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xff0091FF),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.red[900]!,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.red[900]!,
                                ),
                              ),
                              labelText: 'password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    visibility = !visibility;
                                  });
                                },
                                icon: visibility
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),

                          // Button
                          if (isLoading) CircularProgressIndicator(),
                          if (!isLoading)
                            ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xff0091FF)),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(horizontal: 30)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8))),
                              ),
                              onPressed: _submit,
                              child: Text(isLogin ? 'Login' : "SignUp"),
                            ),
                          if (!isLoading)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(isLogin
                                    ? 'Don\'t have an account'
                                    : 'Already have an account'),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isLogin = !isLogin;
                                    });
                                  },
                                  child: Text(isLogin ? "Sign Up Now" : "Sign In"),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Submit function
  void _submit() async {
    final bool isValid = _formKey.currentState!.validate();
    // to close keyboard on clicked
    FocusScope.of(context).unfocus();

    if (!isValid) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Enter All field'),
        ),
      );
      return;
    } else if (!isLogin && selectedImage == null){
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Enter Your Image'),
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          isLoading = true;
        });

        if (isLogin) {
          // user log in
          /// Auth
          await _firebase.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          // user Sign up
          /// Auth
          final UserCredential userCredential =
              await _firebase.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          /// storageRef:- is the PATH of the img inside the Storage
          final Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('User_image')
              .child('${userCredential.user!.uid}.jpg');

          // store user img
          await storageRef.putFile(selectedImage!);
          // Get user img url
          final String imgUrl = await storageRef.getDownloadURL();
          log(imgUrl);

          // Store data in cloud fire store
          final Map<String,dynamic> userData = {
            'username' : username,
            'email' : email,
            'password' : password,
            'imgUrl' : imgUrl,
          };
          /// create users folder (collection) / doc / store (set) the data
          FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(userData);

        }
      } on FirebaseAuthException catch (e) {

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message ?? 'Authentication failed')));

        log(e.message ?? 'Authentication failed');
      }

      setState(() {
        isLoading = true;
      });
    }

    print('Email : $email');
    print('Password : $password');
  }
}
