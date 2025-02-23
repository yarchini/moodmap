import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moodapp/frontend/journal.dart';
import 'package:moodapp/frontend/profile.dart';
import 'package:moodapp/frontend/splash_screen.dart';
import 'package:moodapp/frontend/view_journal.dart';
import 'package:moodapp/frontend/view_journal_home.dart';

void main() {
  runApp(const MoodMapApp());
}

class MoodMapApp extends StatelessWidget {
  const MoodMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/journal': (context) =>
            const ViewJournalHomeScreen(journalEntries: []),
        '/journal-entry': (context) =>
            const JournalEntryScreen(journalEntries: [], chosenEmotion: ''),
        '/trends': (context) => const TrendsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> journalEntries = [
      
      {'date': '2025-02-18', 'emotion': 'Happy'},
      {'date': '2025-02-18', 'emotion': 'Happy'},
      {'date': '2025-02-18', 'emotion': 'Happy'},
      {'date': '2025-02-18', 'emotion': 'Happy'},

      {'date': '2025-02-19', 'emotion': 'Sad'},
      {'date': '2025-02-19', 'emotion': 'Sad'},
      {'date': '2025-02-19', 'emotion': 'Sad'},
      {'date': '2025-02-19', 'emotion': 'Sad'},
    
      {'date': '2025-02-20', 'emotion': 'Neutral'},
      {'date': '2025-02-20', 'emotion': 'Neutral'},
      {'date': '2025-02-20', 'emotion': 'Neutral'},
      
      {'date': '2025-02-21', 'emotion': 'Neutral'},
      {'date': '2025-02-21', 'emotion': 'Neutral'},
      {'date': '2025-02-21', 'emotion': 'Neutral'},

      {'date': '2025-02-22', 'emotion': 'Happy'},
      {'date': '2025-02-22', 'emotion': 'Happy'},
      {'date': '2025-02-22', 'emotion': 'Happy'},
      {'date': '2025-02-22', 'emotion': 'Happy'},
      // Add more entries as needed
    ];

    final moodCounts = _countMoods(journalEntries);
    final entriesByDate = _groupEntriesByDate(journalEntries); // Group entries by date

    return Scaffold(
      appBar: AppBar(
        title: const Text('MoodMap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final shouldLogout = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to exit the app?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
              if (shouldLogout == true) {
                SystemNavigator.pop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTotalEntriesGraph(entriesByDate), // Use the grouped entries
            const SizedBox(height: 16),
            _buildMoodTrackingEntries(moodCounts),
            const SizedBox(height: 16),
            _buildHighlightingPatterns(journalEntries),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate directly to the JournalEntryScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalEntryScreen(
                journalEntries: journalEntries,
                chosenEmotion: '', // Pass an empty string or a default emotion
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/home.png',
                        height: 24, width: 24),
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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewJournalScreen(
                        journalEntries:
                            journalEntries), // Ensure journalEntries is passed correctly
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/journals.png',
                        height: 24, width: 24),
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
                    Image.asset('assets/images/trends.png',
                        height: 24, width: 24),
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
                    Image.asset('assets/images/profile.png',
                        height: 24, width: 24),
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

  Widget _buildTotalEntriesGraph(Map<String, int> entriesByDate) {
    final barGroups = entriesByDate.entries.map((entry) {
      final date = DateTime.parse(entry.key);
      final day = date.day;
      return BarChartGroupData(
        x: day,
        barRods: [
          BarChartRodData(
            y: entry.value.toDouble(),
            colors: [Colors.blue],
            width: 16,
          ),
        ],
      );
    }).toList();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Journal Entries',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200, // Constrain the height of the BarChart
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        return value.toInt().toString();
                      },
                    ),
                    leftTitles: SideTitles(showTitles: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodTrackingEntries(Map<String, int> moodCounts) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mood Tracking Entries',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: moodCounts.entries.map((entry) {
                          return PieChartSectionData(
                            color: _getColorForMood(entry.key),
                            value: entry.value.toDouble(),
                            title: '${entry.value}',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: moodCounts.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: _getColorForMood(entry.key),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${entry.key}: ${entry.value}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightingPatterns(List<Map<String, String>> journalEntries) {
    // Example pattern highlighting logic
    final happyEntries = journalEntries.where((entry) => entry['emotion'] == 'Happy').length;
    final sadEntries = journalEntries.where((entry) => entry['emotion'] == 'Sad').length;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Highlighting Patterns',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            value: happyEntries.toDouble(),
                            title: '$happyEntries',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            value: sadEntries.toDouble(),
                            title: '$sadEntries',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Happy Entries',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Sad Entries',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> _countMoods(List<Map<String, String>> journalEntries) {
    final moodCounts = <String, int>{};

    for (final entry in journalEntries) {
      final emotion = entry['emotion'] ?? 'Unknown';
      moodCounts[emotion] = (moodCounts[emotion] ?? 0) + 1;
    }

    return moodCounts;
  }

  Color _getColorForMood(String mood) {
    switch (mood) {
      case 'Happy':
        return Colors.green;
      case 'Sad':
        return Colors.red;
      case 'Neutral':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Add this method to group entries by date
  Map<String, int> _groupEntriesByDate(List<Map<String, String>> journalEntries) {
    final entriesByDate = <String, int>{};

    for (final entry in journalEntries) {
      final date = entry['date']!;
      entriesByDate[date] = (entriesByDate[date] ?? 0) + 1;
    }

    return entriesByDate;
  }
}

class TrendsScreen extends StatelessWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trends'),
      ),
      body: const Center(
        child: Text('Mood Trends Screen'),
      ),
    );
  }
}
