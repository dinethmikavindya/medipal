import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _previousIndex = 0;
  final notesBox = Hive.box('notesBox');

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _getIconPosition(int index) {
    final width = MediaQuery.of(context).size.width;
    final spacing = width / 5;
    return spacing * index + spacing / 2;
  }

  void _onNavBarTap(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });

    _animationController.forward(from: 0);

    Future.delayed(Duration(milliseconds: 300), () {
      switch (index) {
        case 0:
          // Stay on notes
          break;
        case 1:
          Navigator.pushNamed(context, '/reminders');
          break;
        case 2:
          Navigator.pushNamed(context, '/home');
          break;
        case 3:
          Navigator.pushNamed(context, '/records');
          break;
        case 4:
          Navigator.pushNamed(context, '/settings');
          break;
      }
    });
  }

  void _openNoteEditor({bool isEdit = false, int? index, Map? note}) {
    final titleController = TextEditingController(text: note?["title"] ?? "");
    final contentController = TextEditingController(text: note?["content"] ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                isEdit ? "Edit Note" : "Add Note",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF016274),
                ),
              ),
              SizedBox(height: 24),

              // Title TextField
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFEAFE63), width: 2),
                ),
                child: TextField(
                  controller: titleController,
                  style: GoogleFonts.poppins(fontSize: 15),
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: GoogleFonts.poppins(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Content TextField
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFEAFE63), width: 2),
                ),
                child: TextField(
                  controller: contentController,
                  maxLines: 8,
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: "Content",
                    labelStyle: GoogleFonts.poppins(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: EdgeInsets.all(20),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEAFE63),
                    foregroundColor: Color(0xFF016274),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a title', style: GoogleFonts.poppins()),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final newNote = {
                      "title": titleController.text.trim(),
                      "content": contentController.text.trim(),
                      "date": DateTime.now().toString(),
                    };

                    if (isEdit) {
                      notesBox.putAt(index!, newNote);
                    } else {
                      notesBox.add(newNote);
                    }

                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    isEdit ? "SAVE CHANGES" : "ADD NOTE",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _deleteNote(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Note?',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              notesBox.deleteAt(index);
              Navigator.pop(context);
              setState(() {});
            },
            child: Text('Delete', style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return "Today";
      } else if (difference.inDays == 1) {
        return "Yesterday";
      } else {
        return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
      }
    } catch (e) {
      return "Unknown date";
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryYellow = Color(0xFFEAFE63);
    const Color darkTeal = Color(0xFF016274);
    const Color lightBlue = Color(0xFFEAF7FB);
    const Color lightGrey = Color(0xFFE3E3E3);

    // Group notes by date
    Map<String, List<MapEntry<int, dynamic>>> groupedNotes = {};
    
    for (int i = 0; i < notesBox.length; i++) {
      final note = notesBox.getAt(i);
      final dateLabel = _formatDate(note["date"] ?? DateTime.now().toString());
      
      if (!groupedNotes.containsKey(dateLabel)) {
        groupedNotes[dateLabel] = [];
      }
      groupedNotes[dateLabel]!.add(MapEntry(i, note));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MEDIPAL",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "My Notes",
                            style: GoogleFonts.montserrat(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      // Plus Button
                      GestureDetector(
                        onTap: () => _openNoteEditor(),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: primaryYellow,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryYellow.withOpacity(0.4),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Notes List
                Expanded(
                  child: notesBox.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.note_outlined,
                                size: 80,
                                color: Colors.black26,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No notes yet",
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black38,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Tap the + button to create your first note",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
                          children: groupedNotes.entries.map((dateGroup) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Date Header
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dateGroup.key,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black38,
                                        ),
                                      ),
                                      if (dateGroup.key == groupedNotes.keys.first)
                                        Icon(Icons.search, color: Colors.black38, size: 24),
                                    ],
                                  ),
                                ),
                                
                                // Notes for this date
                                ...dateGroup.value.map((noteEntry) {
                                  final index = noteEntry.key;
                                  final note = noteEntry.value;
                                  
                                  // Determine color based on index pattern
                                  Color noteColor;
                                  if (index % 3 == 0) {
                                    noteColor = lightBlue;
                                  } else if (index % 3 == 1) {
                                    noteColor = primaryYellow;
                                  } else {
                                    noteColor = lightGrey;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _buildNoteCard(
                                      title: note["title"] ?? "Untitled",
                                      content: note["content"] ?? "",
                                      color: noteColor,
                                      onTap: () => _openNoteEditor(
                                        isEdit: true,
                                        index: index,
                                        note: note,
                                      ),
                                      onDelete: () => _deleteNote(index),
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          ),

          // Animated Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                color: darkTeal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated Yellow Circle
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final startPos = _getIconPosition(_previousIndex);
                      final endPos = _getIconPosition(_selectedIndex);
                      final currentPos = startPos + (endPos - startPos) * _animation.value;

                      return Positioned(
                        left: currentPos - 32,
                        top: 7.5,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: primaryYellow,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryYellow.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Navigation Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildNavIcon(Icons.edit_note_outlined, 0),
                      _buildNavIcon(Icons.alarm_add_outlined, 1),
                      _buildNavIcon(Icons.home_outlined, 2),
                      _buildNavIcon(Icons.folder_outlined, 3),
                      _buildNavIcon(Icons.settings_outlined, 4),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard({
    required String title,
    required String content,
    required Color color,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onDelete,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.3,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            if (content.isNotEmpty) ...[
              SizedBox(height: 12),
              Text(
                content,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onNavBarTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        height: 75,
        child: Center(
          child: AnimatedScale(
            scale: isSelected ? 1.1 : 1.0,
            duration: Duration(milliseconds: 200),
            child: Icon(
              icon,
              color: isSelected ? Color(0xFF016274) : Colors.white.withOpacity(0.7),
              size: isSelected ? 30 : 26,
            ),
          ),
        ),
      ),
    );
  }
}