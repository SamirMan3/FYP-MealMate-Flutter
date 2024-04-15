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
  final _firestore = FirebaseFirestore.instance;
  String monday = '',
      tuesday = '',
      wednesday = '',
      thursday = '',
      friday = '',
      saturday = '',
      sunday = '',
      remarks = '';
  Map<String, dynamic> patients = {};

  @override
  void initState() {
    super.initState();
    print(routine);
    getProfile();
  }

  getProfile() async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    try {
      http.Response response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/getProfile'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print("from the userdashboard for get profile");
      var responseData = json.decode(response.body);
      var routine = json.decode(responseData['user']['routine']);
      print("Printing routineeeeeeeeee");
      print(routine);
      sunday = routine['sunday'] ?? '';
      monday = routine['monday'] ?? '';
      tuesday = routine['tuesday'] ?? '';
      wednesday = routine['wednesday'] ?? '';
      thursday = routine['thursday'] ?? '';
      friday = routine['friday'] ?? '';
      saturday = routine['saturday'] ?? '';
      remarks = routine['remarks'] ?? '';

    print(saturday);
      // doctors = responseData['doctor_list'];
      // final newUser= data;
    } catch (e) {
      print('hello from the catch');
      print(e);
    }
    setState(() {
      _buildBody(context);
    });
  }

  void getPatientDetails() async {
    final docDetails = await _firestore
        .collection('doctors')
        .where('doctor name', isEqualTo: docname)
        .get();
    for (var details in docDetails.docs) {
      patients = details.data()['Diet plan for patients'];
      // print(patients);
      // Check if the specified 'email' loggedin with exists in the patients map
      if (patients.containsKey(email)) {
        final patientData = patients[email] as Map<String, dynamic>;
        sunday = patientData['sunday'] ?? '';
        monday = patientData['monday'] ?? '';
        tuesday = patientData['tuesday'] ?? '';
        wednesday = patientData['wednesday'] ?? '';
        thursday = patientData['thursday'] ?? '';
        friday = patientData['friday'] ?? '';
        saturday = patientData['saturday'] ?? '';
      }
    }
    setState(() {
      _buildBody(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(child: _buildBody(context)),
        bottomNavigationBar: _buildBackToHome(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 9.h, vertical: 30.v),
      child: Column(
        children: [
          SizedBox(height: 20.v),
          Text("Prescription Details", style: theme.textTheme.displaySmall),
          SizedBox(height: 20.v),
          Text('by ' + docname, style: theme.textTheme.titleLarge),
          _buildDayWidget(sunday, "Sunday"),
          _buildDayWidget(monday, "Monday"),
          _buildDayWidget(tuesday, "Tuesday"),
          _buildDayWidget(wednesday, "Wednesday"),
          _buildDayWidget(thursday, "Thursday"),
          _buildDayWidget(friday, "Friday"),
          _buildDayWidget(saturday, "Saturday"),
          _buildDayWidget(remarks, "Remarks"),
        ],
      ),
    );
  }

  Widget _buildDayWidget(String day, String dayText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.v),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 18.h),
            child: Text(dayText, style: theme.textTheme.titleLarge),
          ),
        ),
        SizedBox(height: 10.v),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20.h),
            child: Text(day, style: CustomTextStyles.titleLargeBlack90003),
          ),
        ),
      ],
    );
  }

  Widget _buildBackToHome(BuildContext context) {
    return CustomElevatedButton(
      height: 51.v,
      text: "Back To Home",
      margin: EdgeInsets.only(left: 15.h, right: 15.h, bottom: 32.v),
      buttonStyle: CustomButtonStyles.fillPrimaryTL15,
      buttonTextStyle: CustomTextStyles.headlineSmallOnPrimaryContainer,
      onPressed: () {
        onTapBookNow(context);
      },
    );
  }

  onTapBookNow(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userDashboardScreen);
  }
}
