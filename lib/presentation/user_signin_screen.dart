import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mealmate/core/app_export.dart';
import 'package:mealmate/core/utils/config.dart';
import 'package:mealmate/main.dart';
import 'package:provider/provider.dart';
import 'package:mealmate/widgets/custom_elevated_button.dart';
import 'package:mealmate/core/controller/authcontroller.dart'; // Import Provider

class UserSigninScreen extends StatefulWidget { 
  const UserSigninScreen({Key? key}) : super(key: key);

  @override
  _UserSigninScreenState createState() => _UserSigninScreenState();
}

class _UserSigninScreenState extends State<UserSigninScreen> {
  final _formKey = GlobalKey<FormState>(); 
  String password = '', loggedinEmail = '';
  bool obsecurePass = true, notReg = false;
  // final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                  text: "Log In",
                  buttonTextStyle: CustomTextStyles.headlineSmallBlack90004,
                  onPressed: () async {
                    // onTapSignUp(context);
                    loginApi(
                      _emailController.text.toString(),
                      _passwordController.text.toString(),
                    );
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

  void loginApi(String email, String password) async {
    // try {
    // final response = await http.post(
    //   Uri.parse('http://10.0.2.2:8000/api/user/login'),
    //   body: {'email': "test@test.com", 'password': "1234"},
    // );

    // Response response =
    //     await post(Uri.parse('http://10.0.2.2:8000/api/user/login'), body: {
    //   'password': password,
    //   'email': email,
    // });

    // if (response.statusCode == 200) {
    //   print("success");
    //   print(data);
    //   Get.snackbar('Login Successfull', 'Congratulations');
    // } else {
    //   print(data);
    //   Get.snackbar('Login failed', data['error']);
    // }
    try {
      http.Response response = await http
          .post(Uri.parse('http://10.0.2.2:8000/api/user/login'), body: {
        'password': password,
        'email': email,
      });

      // Parse the JSON response
      Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the status is true
      if (responseData['status'] == true) {
        // Access the token from the nested structure
        String token = responseData['token'];

        print(responseData);

        // Now you can use the token
         Provider.of<AuthProvider>(context, listen: false).accessToken = token;
        // .setAccessToken
           Navigator.pushNamed(context, AppRoutes.userDashboardScreen);
      } else {
        // Handle unsuccessful login
        String errorMessage = responseData['message'];
        print('Error: $errorMessage');
      }

      // if (response.statusCode == 201) {
      //   print("from the login function");

      //   print(response.body);
      //   // final newUser= data;
      //   String accessToken = response.body.token;

      //   // Set access token in the context
      //   Provider.of<AuthProvider>(context, listen: false).accessToken =
      //       accessToken;

      //   Navigator.pushNamed(context, AppRoutes.userDashboardScreen);
      //   // print(data);
      //   // Get.snackbar('Login Successfull', 'Congratulations');
      // } else {
      //   print('failed from login');
      // }
    } catch (e) {
      print(e.toString());
    }
  }
}
