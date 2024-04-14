import 'package:flutter/material.dart';
import 'package:mealmate/core/app_export.dart';
import 'package:mealmate/main.dart';
import '../core/utils/image_constant.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_image_view.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:mealmate/core/controller/authcontroller.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  String goal = '', height = '', weight = '', ft = '', inch = '';
  TextEditingController goalController = TextEditingController();
  TextEditingController heightFtController = TextEditingController();
  TextEditingController heightInchController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() {
    // Fetch user data from wherever it's stored
    // For example, you can retrieve it from local storage or global state management
    // For demonstration purposes, I'll set some default values here
    setState(() {
      goal = 'Stay Fit';
      ft = '5';
      inch = '8';
      weight = '70';
      height = '$ft ft $inch inch';
    });
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
          _buildListTile('Goal', goal),
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
                  controller: goalController,
                  decoration: InputDecoration(labelText: 'Goal'),
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

  void _saveUserData() {
    setState(() {
      goal = goalController.text.isNotEmpty ? goalController.text : goal;
      ft = heightFtController.text.isNotEmpty ? heightFtController.text : ft;
      inch = heightInchController.text.isNotEmpty ? heightInchController.text : inch;
      weight = weightController.text.isNotEmpty ? weightController.text : weight;
      height = '$ft ft $inch inch';
    });
  }

  Widget _buildLogOut(BuildContext context) {
    return CustomElevatedButton(
      height: 51.v,
      text: "Log Out",
      margin: EdgeInsets.symmetric(horizontal: 25.h, vertical: 350.v),
      buttonStyle: CustomButtonStyles.fillPrimaryTL15,
      buttonTextStyle: CustomTextStyles.headlineSmallOnPrimaryContainer,
      onPressed: () async{
        _logoutUser(context);
      },
    );
  }
  void _logoutUser(BuildContext context) async {
  final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
  try {
    // Make a POST request to your server's logout endpoint
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/user/logout'),
      headers: {
        'Authorization': 'Bearer $accessToken', // Include the access token in the headers
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
}
