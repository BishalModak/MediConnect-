import 'package:flutter/material.dart';
import '../user_home_screen.dart';
import 'doctor_details_screen.dart';

class DoctorListScreen extends StatelessWidget {
  final String disease;

  DoctorListScreen({required this.disease, super.key});

  final String userName = "John Doe";
  final String userEmail = "john@example.com";

  // 🔹 Sample local doctor list (replace with your real data)
  final List<Map<String, String>> doctors = [
    {
      'name': 'Dr. Ahsan Hossain',
      'info': 'Specialist in Cardiology, 10 years experience'
    },
    {
      'name': 'Dr. Mehnaz Rahman',
      'info': 'Dermatologist, expert in skin treatments'
    },
    {
      'name': 'Dr. Tanvir Ahmed',
      'info': 'Neurologist, focuses on brain and spine care'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$disease Doctors'),
      ),
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
      body: doctors.isEmpty
          ? const Center(
        child: Text(
          'No doctors found for this specialization yet.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctorData = doctors[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailScreen(
                    doctor: {
                      'name': doctorData['name']!,
                      'info': doctorData['info']!,
                    },
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(12.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorData['name'] ?? 'Doctor Name',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            doctorData['info'] ?? 'No additional information.',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blueGrey,
                      size: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
