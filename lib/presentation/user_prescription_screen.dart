import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mealmate/core/app_export.dart';
import 'package:mealmate/main.dart';
import 'package:mealmate/presentation/doctor_dashboard_screen.dart';
import 'package:mealmate/presentation/user_dashboard_screen.dart';
import 'package:mealmate/widgets/custom_elevated_button.dart';
import 'doctor_prescription_screen.dart';
import 'package:mealmate/core/controller/authcontroller.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserPrescriptionScreen extends StatefulWidget {
  final Map<String, dynamic> routine;

  const UserPrescriptionScreen({Key? key, required this.routine})
      : super(key: key);

  // const UserPrescriptionScreen({Key? key}) : super(key: key);

  @override
  _UserPrescriptionScreenState createState() => _UserPrescriptionScreenState();
}

class _UserPrescriptionScreenState extends State<UserPrescriptionScreen> {
  String monday = '', tuesday = '', wednesday = '', thursday = '', friday = '', saturday = '', sunday = '', remarks = '';

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  getProfile() async {
    try {
      http.Response response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/getProfile'),
        headers: {'Authorization': 'Bearer ${Provider.of<AuthProvider>(context, listen: false).accessToken}'},
      );

      var responseData = json.decode(response.body);
      var routine = json.decode(responseData['user']['routine']);

      setState(() {
        sunday = routine['sunday'] ?? '';
        monday = routine['monday'] ?? '';
        tuesday = routine['tuesday'] ?? '';
        wednesday = routine['wednesday'] ?? '';
        thursday = routine['thursday'] ?? '';
        friday = routine['friday'] ?? '';
        saturday = routine['saturday'] ?? '';
        remarks = routine['remarks'] ?? '';
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Prescription Details')),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDayTile(Icons.calendar_today, 'Sunday', sunday),
                _buildDayTile(Icons.calendar_today, 'Monday', monday),
                _buildDayTile(Icons.calendar_today, 'Tuesday', tuesday),
                _buildDayTile(Icons.calendar_today, 'Wednesday', wednesday),
                _buildDayTile(Icons.calendar_today, 'Thursday', thursday),
                _buildDayTile(Icons.calendar_today, 'Friday', friday),
                _buildDayTile(Icons.calendar_today, 'Saturday', saturday),
                SizedBox(height: 20.0),
                _buildDayTile(Icons.notes, 'Remarks', remarks),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBackToHomeButton(),
      ),
    );
  }

  Widget _buildDayTile(IconData icon, String day, String detail) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          day,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        subtitle: Text(
          detail,
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildBackToHomeButton() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.userDashboardScreen);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          'Back To Home',
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }
}