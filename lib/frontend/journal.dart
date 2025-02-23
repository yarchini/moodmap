import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'journal_feedback.dart'; // Import the Journal Feedback screen
import 'nlp_backend.dart'; // Import the NLP backend

class JournalEntryScreen extends StatefulWidget {
  final List<Map<String, String>> journalEntries;
  final String chosenEmotion;
  const JournalEntryScreen({super.key, required this.journalEntries, required this.chosenEmotion});

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final TextEditingController _journalController = TextEditingController();
  String _feedback = '';
  bool _isLoading = false;
  final List<File> _selectedImages = [];
  late List<Map<String, String>> _modifiableJournalEntries;
  String _selectedFontFamily = 'Roboto';
  final List<String> _fontFamilies = ['Roboto', 'Arial', 'Times New Roman', 'Courier New', 'Georgia',
   'Comic Sans MS', 'Trebuchet MS', 'Verdana', 'Impact', 'Lucida Console', 'Palatino Linotype', 
   'Book Antiqua', 'Arial Black', 'Garamond', 'Courier', 'Brush Script MT', 'Copperplate', 'Papyrus'];

  @override
  void initState() {
    super.initState();
    _modifiableJournalEntries = List.from(widget.journalEntries); // Create a modifiable copy of the list
  }

  Future<void> _generateFeedback(String journalEntry) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final feedback = await detectEmotion(journalEntry);
      setState(() {
        _feedback = feedback;
      });
    } catch (e) {
      setState(() {
        _feedback = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  void _saveJournalEntry() {
    final journalEntry = _journalController.text.trim();
    if (journalEntry.isNotEmpty && _feedback.isNotEmpty) {
      setState(() {
        _modifiableJournalEntries.add({
          'date': DateTime.now().toString(),
          'title': '', // Title is removed
          'entry': journalEntry,
          'feedback': _feedback,
          'emotion': widget.chosenEmotion,
          'image': _selectedImages.isNotEmpty ? _selectedImages.map((file) => file.path).join(',') : '',
        });
        _journalController.clear();
        _feedback = '';
        _selectedImages.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Journal entry saved!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields and generate feedback!'),
        ),
      );
    }
  }

  void _addListItem() {
    final currentText = _journalController.text;
    final newText = '$currentText\n• ';
    _journalController.text = newText;
    _journalController.selection = TextSelection.fromPosition(
      TextPosition(offset: _journalController.text.length),
    );
  }

  void _selectFontFamily() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: _fontFamilies.map((String font) {
            return ListTile(
              title: Text(font, style: TextStyle(fontFamily: font)),
              onTap: () {
                setState(() {
                  _selectedFontFamily = font;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final formattedDate = '${currentDate.day}/${currentDate.month}/${currentDate.year}';
    final dayOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][currentDate.weekday - 1];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MoodMap Journal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveJournalEntry,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$dayOfWeek, $formattedDate',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _journalController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write about your day...',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: TextStyle(fontSize: 18, fontFamily: _selectedFontFamily),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ..._selectedImages.map((image) {
                            return Stack(
                              children: [
                                Image.file(
                                  image,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImages.remove(image);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          final journalEntry = _journalController.text.trim();
                          if (journalEntry.isNotEmpty) {
                            _generateFeedback(journalEntry).then((_) {
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JournalFeedbackScreen(
                                    title: '', // Title is removed
                                    date: DateTime.now(),
                                    entry: _journalController.text.trim(),
                                    feedback: _feedback,
                                    emotion: widget.chosenEmotion,
                                    imagePath: _selectedImages.isNotEmpty ? _selectedImages.first.path : null,
                                    onSave: _saveJournalEntry,
                                  ),
                                ),
                              );
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a journal entry!'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 115.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Generate Feedback'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.image),
              onPressed: _pickImage,
            ),
            IconButton(
              icon: const Icon(Icons.font_download),
              onPressed: _selectFontFamily,
            ),
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _addListItem,
            ),
            IconButton(
              icon: const Icon(Icons.tag),
              onPressed: () {
                // Implement add tag functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}