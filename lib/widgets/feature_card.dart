import 'package:flutter/material.dart';
class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? nextPage;

  const FeatureCard({required this.title, required this.icon, this.nextPage});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
          onTap: () {
            if (nextPage != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => nextPage!),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$title clicked")),
              );
            }
          },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.teal[700]),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
