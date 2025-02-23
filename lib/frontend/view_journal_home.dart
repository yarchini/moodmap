import 'package:flutter/material.dart';
import 'dart:io';

class ViewJournalHomeScreen extends StatefulWidget {
  final List<Map<String, String>> journalEntries;

  const ViewJournalHomeScreen({super.key, required this.journalEntries});

  @override
  ViewJournalHomeScreenState createState() => ViewJournalHomeScreenState();
}

class ViewJournalHomeScreenState extends State<ViewJournalHomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> _filteredEntries = [];

  @override
  void initState() {
    super.initState();
    _filteredEntries = widget.journalEntries;
    searchController.addListener(_filterEntries);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterEntries);
    searchController.dispose();
    super.dispose();
  }

  void _filterEntries() {
    final query = searchController.text.toLowerCase();
    setState(() {
      _filteredEntries = widget.journalEntries.where((entry) {
        final title = entry['title']?.toLowerCase() ?? '';
        final content = entry['entry']?.toLowerCase() ?? '';
        return title.contains(query) || content.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Journal'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Entries',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _filteredEntries.length,
              itemBuilder: (context, index) {
                final entry = _filteredEntries[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${entry['date']?.split(' ')[0] ?? ''}',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Journal Entry:',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          entry['entry'] ?? '',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Feedback:',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          entry['feedback'] ?? '',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Emotion:',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          entry['emotion'] ?? '',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (entry['image'] != null && entry['image']!.isNotEmpty)
                          Text(
                          'Uploaded pictures:',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                          Column(
                            children: entry['image']!
                                .split(',')
                                .map((imagePath) => Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Image.file(
                                        File(imagePath),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                );
              },
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