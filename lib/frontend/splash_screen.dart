import 'package:flutter/material.dart';
import 'dart:async';
import 'package:moodapp/frontend/home_screen.dart'; // For timing the splash screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the home screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Container(
            /*decoration: const BoxDecoration(
              color: Colors.lightBlue, // Set your desired background color here
            ), */
           decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splashcover.jpg'), // HD background
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay for contrast
          Container(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.5),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              ClipOval(
                child: Image.asset(
                  'assets/images/logo.jpg', // Replace with MooMap logo
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20.0),
              // App Name
              Text(
                'MoodMap: Digital Journal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto', // Customize with your preferred font
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              // Slogan
              Text(
                'Track Your Emotions, Map Your Mood',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.0),
              // Loading Slider (Circular Progress Indicator)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3.0,
              ),
              SizedBox(height: 20.0),
              // Optional loading text
              Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}
