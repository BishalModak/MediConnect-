import 'package:flutter/material.dart';
import 'package:mediconnect/screens/Sign_in_screen.dart';

import '../widgets/feature_card.dart';
import 'book_doctor/desease_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
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
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bisha Modak',
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'bishalmodak@gmail.com',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
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
            const Divider(
              thickness: 1,
              color: Colors.blue,
              indent: 16,
              endIndent: 16,
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
          FeatureCard(title: 'Call Ambulance', icon: Icons.emergency),
          FeatureCard(title: 'Find Donor', icon: Icons.bloodtype),
          FeatureCard(title: 'Search Hospital', icon: Icons.local_hospital),
          FeatureCard(title: 'Book Doctor', icon: Icons.medical_services, nextPage: DiseaseListScreen(),),
        ],
      ),
    );
  }
}

