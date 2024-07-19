
import 'package:flutter/material.dart';
import 'package:g_app/widgets/sport_widget.dart';
import '../widgets/app_drawer.dart';
import '../widgets/sport_widget.dart'; // Assuming SportWidget is defined in a separate file

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String?>?;
    final firstName = args?['firstName'];
    final lastName = args?['lastName'];
    final phoneNumber = args?['phoneNumber'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: AppDrawer(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        onLogout: () {
          // Optional: Additional logout logic can be added here if needed
        },
      ),
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            SportWidget(imagePath: 'assets/images/football.jpg', name: 'Football'),
            SportWidget(imagePath: 'assets/images/basketball.jpg', name: 'BasketBall'),
            SportWidget(imagePath: 'assets/images/cricket.jpg', name: 'Cricket'),
            SportWidget(imagePath: 'assets/images/tennis.jpg', name: 'Tennis'),
          ],
        ),
      ),
    );
  }
}
