import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mealmate/core/app_export.dart';
import 'package:mealmate/core/utils/config.dart';
import 'package:mealmate/main.dart';
import 'package:mealmate/widgets/custom_elevated_button.dart';

class UserSigninScreen extends StatefulWidget {
  const UserSigninScreen({Key? key}) : super(key: key);

  @override
  _UserSigninScreenState createState() => _UserSigninScreenState();
}

class _UserSigninScreenState extends State<UserSigninScreen> {
  String password = '', loggedinEmail = '';
  bool obsecurePass = true, notReg = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Loading = false;

  bool passwordError = false; // Track password error

  void emailCheck() async {
    final userDoc = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    for (var username in userDoc.docs) {
      loggedinEmail = username.data()['email'];
    }
    // print(loggedinEmail);
    // print(name);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 28.h, vertical: 20.v),
            decoration: BoxDecoration(
                color: appTheme.whiteA700,
                image: DecorationImage(
                    image: AssetImage(ImageConstant.imgsignin),
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgArrowLeft,
                  height: 12.v,
                  width: 18.h,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 7.h),
                  onTap: () {
                    onTapImgArrowLeft(context);
                  },
                ),
                SizedBox(height: 25.v),
                Text(
                  "Welcome to MealMate",
                  style: CustomTextStyles.headlineLargePoppins.copyWith(
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(height: 370.v),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Config.primaryColor,
                  onChanged: (val) {
                    setState(() {
                      email = val; // email is defined in main
                      emailCheck();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                    labelText: 'Email',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.email_outlined),
                    prefixIconColor: Config.primaryColor,
                  ),
                ),
                SizedBox(height: 15.v),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: passwordError ? Colors.red : Config.primaryColor,
                  obscureText: obsecurePass,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                      passwordError = false; // Reset password error on change
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    prefixIconColor: Config.primaryColor,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecurePass = !obsecurePass;
                        });
                      },
                      icon: obsecurePass
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.black38,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                              color: Config.primaryColor,
                            ),
                    ),
                  ),
                  style: TextStyle(
                      color: passwordError
                          ? Colors.red
                          : null), // Set the text color to red on error
                ),
                SizedBox(height: 40.v),
                CustomElevatedButton(
                  text: "Sign In",
                  buttonTextStyle: CustomTextStyles.headlineSmallBlack90004,
                  onPressed: () {
                    loginApi();
                  },
                ),
                SizedBox(height: 10),
                Visibility(
                    visible: notReg,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Email not registered for User's Sign in",
                        style: theme.textTheme.titleLarge,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navigates back to the previous screen.
  void onTapImgArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }

  /// Navigates to the userDashboardScreen when the action is triggered.
  Future<void> onTapSignIn(BuildContext context) async {
    // try {
    // Make a POST request to your API endpoint
    final response = await http.post(
      Uri.parse('http://192.168.1.3:8000/api/user/login'),
      body: {
        'email': "test1@test.com",
        'password': "1234",
        // 'email': email,
        // 'password': password,
      },
    );
    print(response.request);

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Parse the response
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status']) {
        // Authentication successful, navigate to user dashboard
        Navigator.pushNamed(context, AppRoutes.userDashboardScreen);
      } else {
        // Authentication failed, set notReg state to true
        setState(() {
          notReg = true;
        });
      }
    } else {
      // Handle non-200 status code (e.g., server error)
      print(
          'Request failed with status: here ${response.statusCode} ${response.body}');
    }
    // } catch (e) {
    //   // Handle exceptions
    //   print('Error: eta $e');
    //   setState(() {
    //     passwordError = true; // Set password error to true on authentication failure
    //   });
    // }
    // try {
    //   final newUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
    //   if (newUser != null) {
    //     if (loggedinEmail == email){
    //       Navigator.pushNamed(context, AppRoutes.userDashboardScreen);
    //     }else{
    //       setState(() {
    //         notReg = true;
    //       });
    //     }
    //   }
    // } catch (e) {
    //   print(e);
    //   setState(() {
    //     passwordError = true; // Set password error to true on authentication failure
    //   });
    // }
  }

  void loginApi() async {
    try {
      final response = await http.post(
          Uri.parse('http://192.168.1.3:8000/api/user/login'),
          body: {'email': "test1@test.com", 'password': "1234"});

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar('Login Successfull', 'Congratulations');
      } else {
        Get.snackbar('Login failed', data['error']);
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    }
  }
}
