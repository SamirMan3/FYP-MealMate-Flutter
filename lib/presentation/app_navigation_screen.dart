import 'package:flutter/material.dart';
import 'package:mealmate/core/app_export.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFFFFFFF),
        body: SizedBox(
          width: 375.h,
          child: Column(
            children: [
              _buildAppNavigation(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          context,
                          screenTitle: "Home",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(context, AppRoutes.homeScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "User SignIn",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.userSigninScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "OnbordingOne",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.onbordingoneScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Doctor Details",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.doctorDetailsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Successfully Booked",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.successfullyBookedScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "OnbordingThree",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.onbordingthreeScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Signup",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(context, AppRoutes.signupScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "OnbordingTwo",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.onbordingtwoScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "User Dashboard",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.userDashboardScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "User Diet Details",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.userDietDetailsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "OnbordingFour",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.onbordingfourScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "DOctor Signin",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.doctorSigninScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Doctor Dashboard",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.doctorDashboardScreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                "App Navigation",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "Check your app's UI from the below demo screens of your app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF888888),
                  fontSize: 16.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.v),
          Divider(
            height: 1.v,
            thickness: 1.v,
            color: Color(0XFF000000),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle!.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF),
        ),
        child: Column(
          children: [
            SizedBox(height: 10.v),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Text(
                  screenTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0XFF000000),
                    fontSize: 20.fSize,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.v),
            SizedBox(height: 5.v),
            Divider(
              height: 1.v,
              thickness: 1.v,
              color: Color(0XFF888888),
            ),
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(
    BuildContext context,
    String routeName,
  ) {
    Navigator.pushNamed(context, routeName);
  }
}
