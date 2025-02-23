import 'package:flutter/material.dart';
import 'journal.dart'; // Import the JournalEntryScreen

class ChooseEmotion extends StatefulWidget {
  final Function(String) onEmotionChosen;

  const ChooseEmotion({super.key, required this.onEmotionChosen});

  @override
  State<ChooseEmotion> createState() => _ChooseEmotionState();
}

class _ChooseEmotionState extends State<ChooseEmotion> {
  int _emotionIndex = 3; // Default to "Happy"

  // List of emotions
  final List<String> _emotions = ['Sad', 'Angry', 'Neutral', 'Happy', 'Surprised'];
  final List<IconData> _emotionIcons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Emotion'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Icon(
            _emotionIcons[_emotionIndex],
            size: 80,
            color: Colors.black,
          ),
          const SizedBox(height: 10),
          Text(
            _emotions[_emotionIndex],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          Slider(
            value: _emotionIndex.toDouble(),
            min: 0,
            max: (_emotions.length - 1).toDouble(),
            divisions: _emotions.length - 1,
            onChanged: (value) {
              setState(() {
                _emotionIndex = value.toInt();
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onEmotionChosen(_emotions[_emotionIndex]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JournalEntryScreen(
                    journalEntries: [], // Pass the journal entries list here
                    chosenEmotion: _emotions[_emotionIndex],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 115, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/home.png', height: 24, width: 24),
                    const Text(
                      'Home',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/journal'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/journals.png', height: 24, width: 24),
                    const Text(
                      'Journal',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 40), // Space for FAB
            Expanded(
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/trends'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/trends.png', height: 24, width: 24),
                    const Text(
                      'Trends',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/profile.png', height: 24, width: 24),
                    const Text(
                      'Profile',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}