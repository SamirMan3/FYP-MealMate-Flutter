import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealmate/core/app_export.dart';
import 'package:mealmate/core/utils/config.dart';
import 'package:mealmate/widgets/custom_elevated_button.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mealmate/main.dart';
import 'dart:io';
import 'dart:convert';
import 'package:mealmate/core/controller/authcontroller.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int date = int.parse(selectedDay) + 1,
      month = int.parse(selectedMonth) + 1,
      year = 2024 - int.parse(selectedYear),
      ft = int.parse(selectedFeet) + 1,
      inch = int.parse(selectedInch),
      weight = int.parse(selectedWeight) + 30;
  String password = '';
  bool obsecurePass = true;
  // String url =

  // final _auth = FirebaseAuth.instance;
  // final _firestore = FirebaseFirestore.instance;

  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // File? _image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 28.h, vertical: 20.v),
              decoration: BoxDecoration(
                  color: appTheme.whiteA700,
                  image: DecorationImage(
                      image: AssetImage(ImageConstant.imgHome2),
                      fit: BoxFit.cover)),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 7.h, right: 60.h),
                      child: Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgArrowLeft,
                            height: 12.v,
                            width: 18.h,
                            onTap: () {
                              onTapImgArrowLeft(context);
                            },
                          ),
                          Container(
                            height: 9.v,
                            width: 47.h,
                            margin: EdgeInsets.only(left: 14.h, bottom: 3.v),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(4.h),
                            ),
                          ),
                          Container(
                            height: 9.v,
                            width: 47.h,
                            margin: EdgeInsets.only(left: 10.h, bottom: 3.v),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(4.h),
                            ),
                          ),
                          Container(
                            height: 9.v,
                            width: 47.h,
                            margin: EdgeInsets.only(left: 10.h, bottom: 3.v),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(4.h),
                            ),
                          ),
                          Container(
                            height: 9.v,
                            width: 47.h,
                            margin: EdgeInsets.only(left: 10.h, bottom: 3.v),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(4.h),
                            ),
                          ),
                          Container(
                            height: 9.v,
                            width: 47.h,
                            margin: EdgeInsets.only(left: 10.h, bottom: 3.v),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(4.h),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 43.v),
                  Text("Ok, last step!", style: theme.textTheme.titleLarge),
                  SizedBox(height: 32.v),
                  Container(
                    width: 305.h,
                    margin: EdgeInsets.symmetric(horizontal: 34.h),
                    child: Text(
                      "Let’s get you your personalized health plan",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: CustomTextStyles.headlineLargeRegular,
                    ),
                  ),
                  SizedBox(height: 40.v),
                  Text("Sign Up", style: theme.textTheme.headlineLarge),
                  SizedBox(height: 20.v),
                  TextFormField(
                    controller: _firstnameController,
                    keyboardType: TextInputType.name,
                    cursorColor: Config.primaryColor,
                    onChanged: (val) {
                      setState(() {
                        name = val; // name is defined in main
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Userame',
                      labelText: 'Name',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.verified_user),
                      prefixIconColor: Config.primaryColor,
                    ),
                  ),
                  TextFormField(
                    controller: _lastnameController,
                    keyboardType: TextInputType.name,
                    cursorColor: Config.primaryColor,
                    onChanged: (val) {
                      setState(() {
                        name = val; // name is defined in main
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      labelText: 'last',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.verified_user),
                      prefixIconColor: Config.primaryColor,
                    ),
                  ),
                  SizedBox(height: 15.v),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Config.primaryColor,
                    onChanged: (val) {
                      setState(() {
                        email = val; // email is defined in main
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
                    cursorColor: Config.primaryColor,
                    obscureText: obsecurePass,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
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
                                  ))),
                  ),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.name,
                    cursorColor: Config.primaryColor,
                    onChanged: (val) {
                      setState(() {
                        name = val; // name is defined in main
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone number is required';
                      } else if (value.length != 10) {
                        return 'Phone number must be 10 digits long';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: '98########',
                      labelText: 'phone',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.verified_user),
                      prefixIconColor: Config.primaryColor,
                    ),
                  ),
                  SizedBox(height: 35.v),
                  // Image upload button
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor:
                  //         Colors.white, // Set the background color to white
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: 24.0, horizontal: 125.0), // Set padding
                  //   ),
                  //   onPressed: _getImage,
                  //   child: Text(
                  //     "Upload Image",
                  //     style: CustomTextStyles.headlineSmallBlack90004.copyWith(
                  //       color: Colors.black, // Set the text color to black
                  //     ),
                  //   ),
                  // ),
                  // Display selected image
                  // _image != null
                  //     ? Image.file(
                  //         _image!,
                  //         height: 100,
                  //         width: 100,
                  //         fit: BoxFit.cover,
                  //       )
                  //     : Container(),
                  SizedBox(height: 35.v),
                  CustomElevatedButton(
                    text: "Sign Up",
                    buttonTextStyle: CustomTextStyles.headlineSmallBlack90004,
                    onPressed: () async {
                      // onTapSignUp(context);
                      Signup(
                          _firstnameController.text.toString(),
                          _lastnameController.text.toString(),
                          _emailController.text.toString(),
                          _passwordController.text.toString(),
                          _phoneController.text.toString(),
                          context);
                    },
                  ),
                  SizedBox(height: 5.v),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onTapImgArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }

  // Future _getImage() async {
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  Future<void> onTapSignUp(BuildContext context) async {
    // try {
    //   final newUser = await _auth.createUserWithEmailAndPassword(
    //       email: email, password: password);
    //   Navigator.pushNamed(context, AppRoutes.userDashboardScreen);

    //   _firestore.collection('users').add({
    //     'username': name,
    //     'email': email,
    //     'goal': selectedGoal,
    //     'gender': selectedGender,
    //     'birth(date)': date,
    //     'birth(month)': month,
    //     'birth(year)': year,
    //     'height(ft)': ft,
    //     'height(inch)': inch,
    //     'weight': weight,
    //     'doctor name': '',
    //     'medical history': '',
    //     'allergens': ''
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }
}

void Signup(String firstname, String lastname, String email, String password,
    String phonenumber, BuildContext context) async {
  Map<String, dynamic>? args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
  // Check if args is not null before accessing its properties
  var selectedGoal = args?['selectedGoal'];
  var selectedGender = args?['selectedGender'];
  var selectedDate = args?['dob'];
  var selectedWeight = args?['weight'];
  var selectedFeet = args?['feet'];
  var selectedInch = args?['inch'];
  print(args);
  try {
    Response response =
        await post(Uri.parse('http://10.0.2.2:8000/api/user/register'), body: {
      'first_name': firstname,
      'last_name': lastname,
      'password': password,
      'email': email,
      'phone': phonenumber,
      'gender': selectedGender,
      'dob': selectedDate.toIso8601String(),
      'feet': selectedFeet,
      'inch': selectedInch,
      'weight': selectedWeight,
      'goal': selectedGoal,
    });

    if (response.statusCode == 201) {
      Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['status'] == true) {
        // Access the token from the nested structure
        String token = responseData['token'];

        // Now you can use the token
        Provider.of<AuthProvider>(context, listen: false).accessToken = token;
        // .setAccessToken
        print('Token: $token');
        Navigator.pushNamed(context, AppRoutes.userDashboardScreen);
      } else {
        // Handle unsuccessful login
        String errorMessage = responseData['message'];
        print('Error: $errorMessage');
      }
      print('account is created');
      print(response.body);
    } else {
      print('failed');
      print(response.body);
    }
  } catch (e) {
    print(e.toString());
  }
}
