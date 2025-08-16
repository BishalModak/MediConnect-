import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

class DoctorDetailScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;

  DoctorDetailScreen({required this.doctor, super.key});

  @override
  Widget build(BuildContext context) {
    final String doctorName = doctor['name'] ?? 'Doctor Name';
    final String specialization =
        doctor['specialization'] ?? 'General Practitioner';
    final String info = doctor['info'] ?? 'No detailed information available.';
    final String? phoneNumber =
        doctor['phone_number'] ?? "+880123456789"; // Demo number fallback
    final String? address = doctor['address'];
    final String? workingHours = doctor['working_hours'];

    // Function to launch phone dialer
    void _launchCaller(String phone) async {
      final String cleanedPhone = phone.replaceAll(" ", "");
      final Uri callUri = Uri(scheme: 'tel', path: cleanedPhone);

      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the phone dialer')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(doctorName), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.local_hospital,
                        size: 70,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      doctorName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialization,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About Doctor',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const Divider(height: 16, thickness: 1),
                      Text(
                        info,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              if (phoneNumber != null ||
                  address != null ||
                  workingHours != null)
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact & Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const Divider(height: 16, thickness: 1),
                        if (phoneNumber != null)
                          ListTile(
                            leading: const Icon(
                              Icons.phone,
                              color: Colors.green,
                            ),
                            title: Text(phoneNumber),
                            dense: true,
                          ),
                        if (address != null)
                          ListTile(
                            leading: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            title: Text(address),
                            dense: true,
                          ),
                        if (workingHours != null)
                          ListTile(
                            leading: const Icon(
                              Icons.access_time,
                              color: Colors.purple,
                            ),
                            title: Text(workingHours),
                            dense: true,
                          ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.phone),
                  label: const Text(
                    'Call Doctor',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _launchCaller(
                    phoneNumber!,
                  ), // non-null now because of fallback
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
