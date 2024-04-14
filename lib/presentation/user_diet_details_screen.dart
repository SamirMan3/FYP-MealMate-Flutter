import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mealmate/core/app_export.dart';
import 'package:mealmate/main.dart';
import 'package:mealmate/presentation/user_dashboard_screen.dart';
import 'package:mealmate/widgets/custom_elevated_button.dart';
import 'package:mealmate/widgets/custom_text_form_field.dart';
import 'dart:convert';
import 'package:mealmate/core/controller/authcontroller.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;




class UserDietDetailsScreen extends StatefulWidget {
  const UserDietDetailsScreen({Key? key}) : super(key: key);

  @override
  _UserDietDetailsScreenState createState() => _UserDietDetailsScreenState();
}

class _UserDietDetailsScreenState extends State<UserDietDetailsScreen> {
  TextEditingController _medicalHistoryController = TextEditingController();
  TextEditingController _allergensvalueController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;
  String history = '', allergens = '';

  void updateUserDetails() async {
    final userDoc = await _firestore.collection('users').where('email', isEqualTo: email).get();
    for (var userSnapshot in userDoc.docs) {
      final userId = userSnapshot.id;
      final updatedData = {
        'medical history': history,
        'allergens': allergens,
        'doctor name' : selectedDoctor
      };
      // print(history);
      // print(allergens);
      // print(selectedDoctor);
      await _firestore.collection('users').doc(userId).update(updatedData);
    }
  }

  void updateDoctorDetails() async {
    final userDoc = await _firestore.collection('doctors').where('doctor name', isEqualTo: selectedDoctor).get();

    for (var userSnapshot in userDoc.docs) {
      final userId = userSnapshot.id;

      // Fetch the current data
      final currentData = userSnapshot.data() as Map<String, dynamic>;

      // Extract the existing 'Diet plan for patients' data
      final existingDietPlan = currentData['Diet plan for patients'] as Map<String, dynamic>;

      // Define the new data to be added
      final newData = {
        email: {
          'monday': '',
          'tuesday': '',
          'wednesday': '',
          'thursday': '',
          'friday': '',
          'saturday': '',
          'sunday': '',
        },
      };

      // Merge the existing and new data
      final updatedData = {
        'Diet plan for patients': {
          ...existingDietPlan,
          ...newData,
        },
      };

      await _firestore.collection('doctors').doc(userId).update(updatedData);
    }
  }

void   generateDietPlan(history, allergens, doctorId)async{
 print('inside generate the plan');
   print('Medical History: $history');
    print('Allergens: $allergens');
    print('Allergens: $doctorId');
      final accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
       try {
      http.Response response = await http
          .post(Uri.parse('http://10.0.2.2:8000/api/doctor/requestDiet'), headers: {
          'Authorization': 'Bearer $accessToken',
        }, body: {
        'medical_history': history,
        'allergens': allergens,
        'doctor_id': doctorId,
      });

      // Parse the JSON response
      Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
        } catch (e) {
      print(e.toString());
    }
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 15.h, top: 50.v, right: 15.h),
            child: Column(
              children: [
                Text("Enter Details", style: theme.textTheme.displaySmall),
                SizedBox(height: 40.v),
                CustomTextFormField(
                  onChanged: (value) {
                    history = value;
                    // print("Text field content changed: $value");
                  },
                  controller: _medicalHistoryController,
                  hintText: "Medical History",
                  maxLines: 7,
                  contentPadding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 20.v),
                  borderDecoration:
                  TextFormFieldStyleHelper.fillSecondaryContainer,
                  fillColor: theme.colorScheme.secondaryContainer,
                ),
                SizedBox(height: 30.v),
                CustomTextFormField(
                  onChanged: (value) {
                    allergens = value;
                    // print("Text field content changed: $value");
                  },
                  controller: _allergensvalueController,
                  hintText: "Allergens",
                  textInputAction: TextInputAction.done,
                  maxLines: 8,
                  borderDecoration:
                  TextFormFieldStyleHelper.fillSecondaryContainer,
                  fillColor: theme.colorScheme.secondaryContainer,
                ),
                SizedBox(height: 40.v),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildGenerateDietplan(context),
      ),
    );
  }

  Widget _buildGenerateDietplan(BuildContext context) {
      final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
  final String doctorId = args?['doctorId'] ?? ''; // Use default value if doctorId is not provided

    return CustomElevatedButton(
      height: 51.v,
      text: "Generate Diet plan",
      margin: EdgeInsets.only(left: 15.h, right: 15.h, bottom: 32.v),
      buttonStyle: CustomButtonStyles.fillPrimaryTL15,
      buttonTextStyle: CustomTextStyles.headlineSmallOnPrimaryContainer,
      onPressed: () {
        updateUserDetails();
        updateDoctorDetails();
        generateDietPlan(history, allergens, doctorId);
        Navigator.pushNamed(context, AppRoutes.successfullyBookedScreen);
      },
    );
  }
}

