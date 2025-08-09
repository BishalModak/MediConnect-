import 'package:flutter/material.dart';
import 'package:mediconnect/screens/user_home_screen.dart';

import 'doctor_list_screen.dart';

class DiseaseListScreen extends StatelessWidget {
  DiseaseListScreen({super.key});

  final List<String> diseases = [
    "Cardiology",
    "Dermatology",
    "Neurology",
    "Pediatrics",
    "Orthopedics",
    "Ophthalmology",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Disease')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> UserHomeScreen()));
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
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: diseases.map((disease) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorListScreen(disease: disease),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.medical_services,
                      color: Colors.teal[700],
                      size: 30,
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        disease,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
