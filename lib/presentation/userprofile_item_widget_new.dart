import 'package:flutter/material.dart';
import 'package:mealmate/core/app_export.dart';

class UserprofileItemWidgetNew extends StatefulWidget {
  final String doctorName;
  final int doctorID;
  final void Function(String?, int?)? onTapUserProfile;

  UserprofileItemWidgetNew({
    Key? key,
    required this.doctorName,
    required this.doctorID,
    this.onTapUserProfile,
  }) : super(key: key);

  @override
  _UserprofileItemWidgetNewState createState() => _UserprofileItemWidgetNewState();
}

class _UserprofileItemWidgetNewState extends State<UserprofileItemWidgetNew> {
  @override
  Widget build(BuildContext context) {
    //doctor profile id
    // print("doctor id");
    // print(widget.doctorID);
         Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // Check if args is not null before accessing its properties
    var selectedGoal = args?['id'];
    return GestureDetector(
      onTap: () {
        print(widget.doctorID);
        widget.onTapUserProfile?.call(widget.doctorName,widget.doctorID);
      },
      child: Container(
        padding: EdgeInsets.all(7.h),
        decoration: AppDecoration.fillGray50.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder15,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgD11,
              height: 65.v,
              width: 68.h,
              radius: BorderRadius.circular(
                32.h,
              ),
              margin: EdgeInsets.only(top: 6.v),
            ),
            Spacer(
              flex: 27,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 24.v,
                bottom: 18.v,
              ),
              child: Text(
                widget.doctorName,
                // widget.doctorID,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Spacer(
              flex: 72,
            ),
            CustomImageView(
              imagePath: ImageConstant.imgArrowRight,
              height: 25.v,
              width: 13.h,
              margin: EdgeInsets.only(
                top: 23.v,
                right: 20.h,
                bottom: 22.v,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
