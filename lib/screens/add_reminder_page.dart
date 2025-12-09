import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryYellow = Color(0xFFEAFE63);
    const Color darkTeal = Color(0xFF016274);
    const Color lightBlue = Color(0xFFEAF7FB);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "MEDIPAL",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            Text(
              "Add Reminder",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
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
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _medicineTab(),
          _activityTab(),
          _appointmentTab(),
          _customTab(),
        ],
      ),
    );
  }

  Widget _medicineTab() {
    TextEditingController medName = TextEditingController();
    TextEditingController dosage = TextEditingController();
    TextEditingController notes = TextEditingController();

    String mealRelation = "After Meal";
    String frequency = "Daily";
    String duration = "7 Days";

    TimeOfDay? selectedTime;

    return _scrollableForm(
      children: [
        _title("Medicine Name"),
        _textField(medName, "e.g. Panadol 500mg"),

        _title("Dosage"),
        _textField(dosage, "e.g. 1 tablet"),

        _title("Meal Relation"),
        _dropdown(
          value: mealRelation,
          items: [
            "Before Meal",
            "After Meal",
            "With Meal",
            "No Relation",
            "10 min before meal",
            "30 min before meal",
            "10 min after meal",
            "30 min after meal",
          ],
          onChanged: (v) => setState(() => mealRelation = v!),
        ),

        _title("Reminder Time"),
        _timePickerButton(onPicked: (t) => selectedTime = t),

        _title("Frequency"),
        _dropdown(
          value: frequency,
          items: [
            "Daily",
            "Every Morning",
            "Every Night",
            "Every 8 Hours",
            "Specific Days of Week",
          ],
          onChanged: (v) => setState(() => frequency = v!),
        ),

        _title("Duration"),
        _dropdown(
          value: duration,
          items: [
            "3 Days",
            "5 Days",
            "7 Days",
            "14 Days",
            "1 Month",
            "Custom",
          ],
          onChanged: (v) => setState(() => duration = v!),
        ),

        _title("Notes (Optional)"),
        _textField(notes, "e.g. Take with warm water"),

        _saveButton(),
      ],
    );
  }

  Widget _activityTab() {
    TextEditingController activityName = TextEditingController();
    TextEditingController description = TextEditingController();
    String repeat = "Daily";
    TimeOfDay? selectedTime;

    return _scrollableForm(
      children: [
        _title("Activity Name"),
        _textField(activityName, "e.g. Walk • Drink Water • Exercise"),

        _title("Time"),
        _timePickerButton(onPicked: (t) => selectedTime = t),

        _title("Repeat"),
        _dropdown(
          value: repeat,
          items: [
            "Once",
            "Daily",
            "Every Morning",
            "Every Night",
            "Every 2 Hours",
            "Weekly",
          ],
          onChanged: (v) => setState(() => repeat = v!),
        ),

        _title("Description (Optional)"),
        _textField(description, "e.g. 2 cups of water"),

        _saveButton(),
      ],
    );
  }

  Widget _appointmentTab() {
    TextEditingController doctor = TextEditingController();
    TextEditingController hospital = TextEditingController();
    TextEditingController purpose = TextEditingController();

    DateTime? appointmentDate;
    TimeOfDay? appointmentTime;

    return _scrollableForm(
      children: [
        _title("Doctor Name"),
        _textField(doctor, "e.g. Dr. Silva"),

        _title("Hospital / Clinic"),
        _textField(hospital, "e.g. Lanka Hospital"),

        _title("Purpose"),
        _textField(purpose, "e.g. Checkup / Follow-up"),

        _title("Date"),
        _datePickerButton(onPicked: (d) => appointmentDate = d),

        _title("Time"),
        _timePickerButton(onPicked: (t) => appointmentTime = t),

        _saveButton(),
      ],
    );
  }

  Widget _customTab() {
    TextEditingController title = TextEditingController();
    TextEditingController desc = TextEditingController();
    TimeOfDay? selectedTime;

    return _scrollableForm(
      children: [
        _title("Title"),
        _textField(title, "e.g. Take a break"),

        _title("Time"),
        _timePickerButton(onPicked: (t) => selectedTime = t),

        _title("Description (Optional)"),
        _textField(desc, "Add more details"),

        _saveButton(),
      ],
    );
  }

  Widget _scrollableForm({required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: children),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController c, String hint) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFEAFE63), width: 2),
      ),
      child: TextField(
        controller: c,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.black38),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFEAFE63), width: 2),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: Color(0xFF016274)),
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
        ),
        dropdownColor: Colors.white,
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _timePickerButton({required Function(TimeOfDay) onPicked}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFEAF7FB),
          foregroundColor: Color(0xFF016274),
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Color(0xFFEAFE63), width: 2),
          ),
        ),
        onPressed: () async {
          TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Color(0xFFEAFE63),
                    onPrimary: Color(0xFF016274),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) onPicked(picked);
        },
        icon: Icon(Icons.access_time, size: 20),
        label: Text(
          "Pick Time",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _datePickerButton({required Function(DateTime) onPicked}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFEAF7FB),
          foregroundColor: Color(0xFF016274),
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Color(0xFFEAFE63), width: 2),
          ),
        ),
        onPressed: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            initialDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Color(0xFFEAFE63),
                    onPrimary: Color(0xFF016274),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) onPicked(picked);
        },
        icon: Icon(Icons.calendar_today, size: 20),
        label: Text(
          "Pick Date",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 20),
      child: SizedBox(
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
            shadowColor: Color(0xFFEAFE63).withOpacity(0.4),
          ),
          onPressed: () {
            // Show success message
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Color(0xFF016274),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(0xFFEAFE63),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFEAFE63).withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check,
                          size: 50,
                          color: Color(0xFF016274),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "New reminder\nAdded",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            // Auto close and navigate back after 2 seconds
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to reminder list
            });
          },
          child: Text(
            "SAVE REMINDER",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}