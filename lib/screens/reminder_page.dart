import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_reminder_page.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  int _selectedIndex = 1;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _previousIndex = 1;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    
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
          Navigator.pushNamed(context, '/notes');
          break;
        case 1:
          // Stay on reminders
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

  @override
  Widget build(BuildContext context) {
    const Color primaryYellow = Color(0xFFEAFE63);
    const Color darkTeal = Color(0xFF016274);
    const Color lightBlue = Color(0xFFEAF7FB);

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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Column(
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
                        "Reminders",
                        style: GoogleFonts.montserrat(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab Bar
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                      color: primaryYellow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.all(4),
                    labelColor: darkTeal,
                    unselectedLabelColor: Colors.black54,
                    labelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    unselectedLabelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    tabs: const [
                      Tab(text: "Medicine"),
                      Tab(text: "Activity"),
                      Tab(text: "Appointment"),
                      Tab(text: "Custom"),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      buildReminderList("Medicine"),
                      buildReminderList("Activity"),
                      buildReminderList("Appointment"),
                      buildReminderList("Custom"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Add Reminder Button (Above Nav Bar)
          Positioned(
            bottom: 90,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddReminderPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryYellow,
                foregroundColor: Colors.black,
                elevation: 4,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadowColor: primaryYellow.withOpacity(0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 24),
                  SizedBox(width: 8),
                  Text(
                    "New Reminder",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
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

  Widget buildReminderList(String category) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        ReminderCard(
          title: category == "Medicine" ? "Panadol 500mg" : "Sample Reminder",
          time: "8:00 AM",
          description: category == "Medicine"
              ? "After meal • 1 tablet"
              : "Description here",
          category: category,
        ),
        ReminderCard(
          title: category == "Medicine" ? "Vitamin D" : "Morning Walk",
          time: "9:00 AM",
          description: category == "Medicine"
              ? "Before meal • 1 capsule"
              : "30 minutes walk",
          category: category,
        ),
      ],
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

class ReminderCard extends StatefulWidget {
  final String title;
  final String time;
  final String description;
  final String category;

  const ReminderCard({
    super.key,
    required this.title,
    required this.time,
    required this.description,
    required this.category,
  });

  @override
  State<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  bool active = true;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: slideRight(),
      secondaryBackground: slideLeft(),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // EDIT
        } else {
          // DELETE
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFFEAF7FB),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 2),
              color: Colors.black.withOpacity(0.05),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(0xFFEAFE63).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(widget.category),
                size: 28,
                color: const Color(0xFF016274),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getTimeIcon(),
                        size: 16,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.time,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  if (widget.description.isNotEmpty) ...[
                    SizedBox(height: 2),
                    Text(
                      widget.description,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: active ? Color(0xFFEAFE63) : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    active ? Icons.check : Icons.close,
                    color: active ? Color(0xFF016274) : Colors.grey[600],
                    size: 20,
                  ),
                ),
                SizedBox(height: 4),
                Switch(
                  value: active,
                  activeColor: Color(0xFFEAFE63),
                  activeTrackColor: Color(0xFF016274),
                  inactiveThumbColor: Colors.grey[400],
                  inactiveTrackColor: Colors.grey[300],
                  onChanged: (v) => setState(() => active = v),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
      case "Medicine":
        return Icons.medication_rounded;
      case "Activity":
        return Icons.directions_walk_rounded;
      case "Appointment":
        return Icons.calendar_month_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  IconData _getTimeIcon() {
    final hour = int.tryParse(widget.time.split(':')[0]) ?? 0;
    if (hour >= 5 && hour < 12) return Icons.wb_sunny_rounded;
    if (hour >= 12 && hour < 17) return Icons.wb_sunny_outlined;
    if (hour >= 17 && hour < 20) return Icons.nightlight_round;
    return Icons.nights_stay_rounded;
  }

  Widget slideRight() => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Color(0xFF016274),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.edit, color: Colors.white, size: 30),
      );

  Widget slideLeft() => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      );
}