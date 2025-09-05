import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mediconnect/screens/call_ambulance/Call_ambulance_main_screen.dart';

import '../widgets/feature_card.dart';
import 'book_doctor/desease_screen.dart';
import 'Sign_in_screen.dart'; // for redirecting after logout

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  String? userName;
  String? userEmail;
  String? userPhoto;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    if (user != null) {
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child("user")
          .child(user!.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          userName = snapshot.child("name").value.toString();
          userEmail = snapshot.child("email").value.toString();
          userPhoto = user?.photoURL; // optional
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediConnect+'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    backgroundImage:
                    userPhoto != null ? NetworkImage(userPhoto!) : null,
                    child: userPhoto == null
                        ? Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue[800],
                    )
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName ?? 'User Name',
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    userEmail ?? 'user@email.com',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            // Home Option
            ListTile(
              title: const Text('Home'),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Divider(
              thickness: 1,
              color: Colors.blue,
              indent: 16,
              endIndent: 16,
            ),

            // Logout Option
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const signInScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          FeatureCard(
            title: 'Call Ambulance',
            icon: Icons.emergency,
            nextPage: CallAmbulanceMainScreen(),
          ),
          FeatureCard(title: 'Find Donor', icon: Icons.bloodtype),
          FeatureCard(title: 'Search Hospital', icon: Icons.local_hospital),
          FeatureCard(
            title: 'Book Doctor',
            icon: Icons.medical_services,
            nextPage: DiseaseListScreen(),
          ),
        ],
      ),
    );
  }
}
