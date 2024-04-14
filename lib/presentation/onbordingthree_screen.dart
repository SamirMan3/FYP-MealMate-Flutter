import 'package:flutter/material.dart';
import 'package:mealmate/core/app_export.dart';
import 'package:mealmate/widgets/custom_elevated_button.dart';
import 'package:mealmate/theme/theme_helper.dart';
import 'package:mealmate/main.dart';

class OnbordingthreeScreen extends StatefulWidget {
  const OnbordingthreeScreen({Key? key}) : super(key: key);

  @override
  _OnbordingthreeScreenState createState() => _OnbordingthreeScreenState();
}

class _OnbordingthreeScreenState extends State<OnbordingthreeScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 18.v),
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
                  padding: EdgeInsets.only(left: 23.h, right: 76.h),
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
                        margin: EdgeInsets.only(
                          left: 14.h,
                          top: 2.v,
                          bottom: 1.v,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Container(
                        height: 9.v,
                        width: 47.h,
                        margin: EdgeInsets.only(
                          left: 10.h,
                          top: 2.v,
                          bottom: 1.v,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Container(
                        height: 9.v,
                        width: 47.h,
                        margin: EdgeInsets.only(
                          left: 10.h,
                          top: 2.v,
                          bottom: 1.v,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Container(
                        height: 9.v,
                        width: 47.h,
                        margin: EdgeInsets.only(
                          left: 10.h,
                          top: 2.v,
                          bottom: 1.v,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.blueGray100,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Container(
                        height: 9.v,
                        width: 47.h,
                        margin: EdgeInsets.only(
                          left: 10.h,
                          top: 2.v,
                          bottom: 1.v,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.blueGray100,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 56.v),
              Text("Next step", style: theme.textTheme.titleLarge),
              SizedBox(height: 65.v),
              SizedBox(
                height: 90.v,
                width: 260.h,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "What is your date of birth?",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.headlineLargeRegular,
                  ),
                ),
              ),
              SizedBox(height: 65.v),
              Column(
                children: [
                  CustomElevatedButton(
                    text: "Select date",
                    onPressed: () {
                      _selectDate(context);
                    },
                    // child: Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(selectedDate != null
                    //       ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                    //       : "Select Date"),
                    // ),
                  ),
                  if (selectedDate != null)
                    Text(
                      "Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      style: TextStyle(fontSize: 20),
                    ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildNextButton(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildNextButton(BuildContext context) {
    return CustomElevatedButton(
      text: "NEXT",
      margin: EdgeInsets.only(left: 28.h, right: 28.h, bottom: 49.v),
      onPressed: () {
        onTapNextButton(context);
      },
    );
  }

  /// Navigates back to the previous screen.
  onTapImgArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }

  /// Navigates to the onbordingfourScreen when the action is triggered.
  onTapNextButton(BuildContext context) {
    Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    // Check if args is not null before accessing its properties
    var selectedGoal = args?['selectedGoal'];
    var selectedGender = args?['selectedGender'];
    Navigator.pushNamed(
      context,
      AppRoutes.onbordingfourScreen,
      arguments: {
        'dob': selectedDate,
        'selectedGender': selectedGender,
        'selectedGoal': selectedGoal
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print('################################################');
        print(picked);
      });
  }
}
