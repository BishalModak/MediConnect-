import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mediconnect/screens/user_home_screen.dart';
import 'package:mediconnect/widgets/LoginAppbar.dart';

import '../widgets/Custom_Text_Field.dart';
import 'Sign_in_screen.dart';
import 'call_ambulance/global/global.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authResult = await firebaseAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        currentUser = authResult.user;

        if (currentUser != null) {
          await currentUser!.updateDisplayName(nameController.text.trim());
          await currentUser!.reload();
          currentUser = firebaseAuth.currentUser;

          Map userMap = {
            "id": currentUser!.uid,
            "name": nameController.text.trim(),
            "email": emailController.text.trim(),
            "address": addressController.text.trim(),
            "phone": phoneController.text.trim(),
          };

          DatabaseReference userRef = FirebaseDatabase.instance.ref().child("user");
          await userRef.child(currentUser!.uid).set(userMap);

          Fluttertoast.showToast(msg: "Successfully Registered");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const signInScreen()),
          );
        } else {
          Fluttertoast.showToast(msg: "Failed to create user.");
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Error: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "Please fill all fields correctly.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loginAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Name Field
                CustomTextField(
                  hintText: 'Enter Your Name',
                  controller: nameController,
                ),
                const SizedBox(height: 10),

                // Phone Field
                CustomTextField(
                  hintText: 'Enter Your Phone Number',
                  controller: phoneController,
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),

                // Email Field
                CustomTextField(
                  hintText: 'Enter Your Email',
                  controller: emailController,
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 10),

                // Address Field
                CustomTextField(
                  hintText: 'Address',
                  controller: addressController,
                  prefixIcon: Icons.location_city,
                ),
                const SizedBox(height: 10),

                // Password Field
                CustomTextField(
                  hintText: 'Enter Password',
                  controller: passwordController,
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // Confirm Password Field
                CustomTextField(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                // Register Button
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.blue.shade300,
                  ),
                ),
                const SizedBox(height: 20),

                // SignIn link
                RichText(
                  text: TextSpan(
                    text: "Have an Account? ",
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black, letterSpacing: 0.5, fontSize: 15),
                    children: [
                      TextSpan(
                        text: 'SignIn',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = onTapSignUpButton,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTapSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => signInScreen()),
    );
  }
}
