import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mealmate/core/app_export.dart';
import 'package:mealmate/main.dart';
import '../core/utils/image_constant.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_image_view.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:mealmate/core/controller/authcontroller.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  String goal = '',
      height = '',
      weight = '',
      ft = '',
      inch = '',
      first_name = '',
      last_name = '',
      dob = '';
  TextEditingController goalController = TextEditingController();
  TextEditingController heightFtController = TextEditingController();
  TextEditingController heightInchController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController first_nameController = TextEditingController();
  TextEditingController last_nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    // Fetch user data from wherever it's stored
    // For example, you can retrieve it from local storage or global state management
    // For demonstration purposes, I'll set some default values here
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
      print(responseData);
      int heightInInches =
          int.tryParse(responseData['user']?['height'] ?? '') ?? 0;
      // int heightInInches = responseData['user']?['height'];
      int feet = heightInInches ~/ 12;
      int inches = heightInInches % 12;
      print(feet);
      print(inches);
      setState(() {
        first_name = responseData['user']?['first_name'];
        last_name = responseData['user']?['last_name'];
        goal = responseData['user']?['goal'];
        dob = responseData['user']?['date_of_birth'];
        ft = feet.toString();
        inch = inches.toString();
        height = '$ft ft $inch inch';
        weight = responseData['user']?['weight'];

        first_nameController.text = responseData['user']?['first_name'];
        last_nameController.text = responseData['user']?['last_name'];
        goalController.text = goal;
        _dobController.text = responseData['user']?['date_of_birth'];
        heightFtController.text = ft;
        heightInchController.text = inch;
        weightController.text = weight;
      });
    } catch (e) {
      print("Hello from catch user drawerrrrr");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF41AC60),
            ),
            child: Row(
              children: [
                SizedBox(width: 10.v),
                CustomImageView(
                  imagePath: ImageConstant.userimg,
                  height: 100.v,
                  radius: BorderRadius.circular(100.h),
                  margin: EdgeInsets.only(top: 6.v),
                ),
                SizedBox(width: 30.v),
                Padding(
                  padding: EdgeInsets.only(
                    top: 24.v,
                    bottom: 18.v,
                  ),
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          _buildListTile('First Name', first_name),
          _buildListTile('Last Name', last_name),
          _buildListTile('Goal', goal),
          _buildListTile('Date of Birth', dob),
          _buildListTile('Height', height),
          _buildListTile('Weight', weight),
          SizedBox(height: 20.v),
          _buildEditButton(context),
          SizedBox(height: 20.v),
          _buildLogOut(context),
        ],
      ),
    );
  }

  Widget _buildListTile(String text, String value) {
    return ListTile(
      title: Row(
        children: [
          SizedBox(width: 10.v),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
          Spacer(flex: 2),
          Text(value),
          SizedBox(width: 10.v),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return CustomElevatedButton(
      height: 51.v,
      text: "Edit Profile",
      margin: EdgeInsets.symmetric(horizontal: 25.h),
      buttonStyle: CustomButtonStyles.fillPrimaryTL15,
      buttonTextStyle: CustomTextStyles.headlineSmallOnPrimaryContainer,
      onPressed: () {
        _showEditDialog(context);
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: first_nameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                ),
                TextFormField(
                  controller: last_nameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
                TextFormField(
                  controller: goalController,
                  decoration: InputDecoration(labelText: 'Goal'),
                ),
                TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(labelText: 'Date of birth'),
                  onTap: () {
                    _selectDate(context);
                  },
                ),
                SizedBox(height: 10.v),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: heightFtController,
                        decoration: InputDecoration(labelText: 'Height (ft)'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10.h),
                    Expanded(
                      child: TextFormField(
                        controller: heightInchController,
                        decoration: InputDecoration(labelText: 'Height (inch)'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[1-9]|1[0-1]?$')),
                          LengthLimitingTextInputFormatter(
                              2), // Allows numbers between 1 and 11
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.v),
                TextFormField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: 'Weight'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveUserData();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // void _saveUserData() {
  //   setState(() {
  //     goal = goalController.text.isNotEmpty ? goalController.text : goal;
  //     ft = heightFtController.text.isNotEmpty ? heightFtController.text : ft;
  //     inch = heightInchController.text.isNotEmpty ? heightInchController.text : inch;
  //     weight = weightController.text.isNotEmpty ? weightController.text : weight;
  //     height = '$ft ft $inch inch';
  //   });
  // }
  void _saveUserData() async {
    setState(() {
      first_name = first_nameController.text.isNotEmpty
          ? first_nameController.text
          : first_name;
      last_name = last_nameController.text.isNotEmpty
          ? last_nameController.text
          : last_name;
      goal = goalController.text.isNotEmpty ? goalController.text : goal;
      dob = _dobController.text.isNotEmpty ? _dobController.text : dob;
      ft = heightFtController.text.isNotEmpty ? heightFtController.text : ft;
      inch = heightInchController.text.isNotEmpty
          ? heightInchController.text
          : inch;
      weight =
          weightController.text.isNotEmpty ? weightController.text : weight;
      height = '$ft ft $inch inch';
    });
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    http.Response response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/user/updateProfile'),
        headers: {
          'Authorization':
              'Bearer $accessToken', // Include the access token in the headers
        },
        body: {
          // 'first_name': firstname,
          // 'last_name': lastname,
          // 'password': password,
          // 'email': email,
          // 'phone': phonenumber,
          // 'gender': selectedGender,
          // 'dob': selectedDate.toIso8601String(),
          'feet': ft,
          'inch': inch,
          'weight': weight,
          'goal': goal,
          'first name': first_name,
          'last name': last_name,
          'dob': dob
        });
    var responseData = json.decode(response.body);
    print(responseData);
  }

  Widget _buildLogOut(BuildContext context) {
    return CustomElevatedButton(
      height: 50.v,
      text: "Log Out",
      margin: EdgeInsets.symmetric(horizontal: 25.h, vertical: 240.v),
      buttonStyle: CustomButtonStyles.fillPrimaryTL15,
      buttonTextStyle: CustomTextStyles.headlineSmallOnPrimaryContainer,
      onPressed: () async {
        _logoutUser(context);
      },
    );
  }

  void _logoutUser(BuildContext context) async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    try {
      // Make a POST request to your server's logout endpoint
      var response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/user/logout'),
        headers: {
          'Authorization':
              'Bearer $accessToken', // Include the access token in the headers
        },
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // If successful, navigate back to the home screen
        Navigator.pushNamed(context, AppRoutes.homeScreen);
      } else {
        // If not successful, handle the error (display a message, etc.)
        Navigator.pushNamed(context, AppRoutes.homeScreen);
        print("Logout failed: ${response.body}");
        // You can display an error message to the user or handle it in any way you prefer
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      Navigator.pushNamed(context, AppRoutes.homeScreen);
      print("Error logging out: $e");
      // You can display an error message to the user or handle it in any way you prefer
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate1 = dob != null ? DateTime.parse(dob) : DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate1 ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != initialDate1)
      setState(() {
        initialDate1 = picked;
        String formattedDate =
            DateFormat('yyyy-MM-dd').format(picked); // Format the picked date
        _dobController.text =
            formattedDate; // Set the formatted date to the text field
        dob = formattedDate; // Store the formatted date in the dob variable
        print('################################################');
        print(picked);
      });
  }
}
