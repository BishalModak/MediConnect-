import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mediconnect/widgets/LoginAppbar.dart';

import '../widgets/Custom_Text_Field.dart';
import 'Sign_in_screen.dart';
class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loginAppbar(),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  CustomTextField(hintText: 'Enter Your Name', prefixIcon: null, controller: firstNameController,),
                  SizedBox(height: 10),
                  CustomTextField(hintText: 'Enter Your Phone Number', controller: phoneController,prefixIcon: Icons.phone , keyboardType: TextInputType.phone,),
                  SizedBox(height: 10),
                  CustomTextField(hintText: 'Enter Your Email', controller: emailController, prefixIcon: Icons.email,),
                  SizedBox(height: 10),
                  CustomTextField(hintText: 'Enter Password', controller: passwordController, prefixIcon: Icons.lock,),
                  SizedBox(height: 10),
                  CustomTextField(hintText: 'Confirm Password', controller: confirmPasswordController, prefixIcon: Icons.lock,),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Register', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.blue.shade300
                    ),
                  ),
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: "Have an Account? ",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: 0.5,
                          fontSize: 15
                      ),
                      children: [
                        TextSpan(
                          text: 'SignIn',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = onTapSignUpButton,
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => signInScreen()));
  }
}

