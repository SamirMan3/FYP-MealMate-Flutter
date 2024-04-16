import 'package:mealmate/core/controller/authcontroller.dart';
import 'package:mealmate/presentation/doctor_details_screen_Id.dart';
import 'package:mealmate/presentation/user_prescription_screen.dart';
import 'package:flutter/material.dart';
import 'package:mealmate/presentation/userprofile_item_widget_new.dart';
import 'package:mealmate/presentation/userprofilesection_item_widget.dart';
import 'package:provider/provider.dart';
import 'userprofile_item_widget.dart';
import 'package:mealmate/core/app_export.dart';
import 'package:mealmate/widgets/app_bar/appbar_leading_image.dart';
import 'user_drawer.dart';
import 'package:mealmate/widgets/app_bar/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:mealmate/main.dart';
import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

String selectedDoctor = ''; // for booking screen
String selectedDoctorId = ''; // for booking screen
String docname = ''; // for pre-booked screen
final Map<String, dynamic> routine = {};

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  // final _firestore = FirebaseFirestore.instance;

  List doctors = [];
  String goal = '';
  Map<String, String> products = {};

  @override
  void initState() {
    super.initState();
    getProfile();
    getDoctors();
    // fetchData();
  }

  // Future<void> fetchData() async {
  //   await getProducts(); // Wait for getProducts to complete
  // }

  //firebase
  // getName() async {
  //   final userDoc = await _firestore
  //       .collection('users')
  //       .where('email', isEqualTo: email)
  //       .get();
  //   for (var username in userDoc.docs) {
  //     name = username.data()['username'];
  //     docname = username.data()['doctor name'];
  //     goal = username.data()['goal'];
  //   }
  //   setState(() {
  //     _buildDietitiansProfile(context);
  //     getProducts();
  //     fetchData();
  //   });
  // }

  //firebase
  getDoctors() async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    try {
      http.Response response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/dashboard'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      var responseData = json.decode(response.body);
      doctors.clear();

      // Iterate through responseData and extract doctor data
      for (var doctorData in responseData['doctor_list']) {
        doctors.add(doctorData);
      }
      // doctors = responseData['doctor_list'];
      // final newUser= data;
    } catch (e) {
      print('hello from the catch');
      print(e);
    }
    setState(() {
      _buildDietitiansProfile(context);
    });
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
      // var routine = json.decode(responseData['user']['routine']!);
      print("Printing routineeeeeeeeee");
      print(routine);
      name = responseData['user']?['first_name'];
      docname = responseData['my_doctor']?['first_name'] ?? '';
      if (response.statusCode == 201) {
        String firstName = responseData['user']?['first_name'] ?? '';
        String lastName = responseData['user']?['last_name'] ?? '';
        String docFirstName = responseData['my_doctor']?['first_name'] ?? '';
        String docLastName = responseData['my_doctor']?['last_name'] ?? '';

// Concatenate first and last name
        String fullName = '$firstName $lastName';
        String docFullName = '$docFirstName $docLastName';

        docname = docFirstName;
        print(name);
      }
    } catch (e) {
      print('hello from the catch');
      print(e);
    }
    setState(() {
      _buildDietitiansProfile(context);
    });
  }

  //firebase
  List<String> names = [];
  List<String> descriptions = [];
  List<String> links = [];
  // Future<void> getProducts() async {
  //   await for (var snapshot in _firestore.collection(goal).snapshots()) {
  //     // Clear lists before populating them in each iteration
  //     names.clear();
  //     descriptions.clear();
  //     links.clear();
  //     for (var product in snapshot.docs) {
  //       var prod = product.data();
  //       // Extract values from the map and add them to the lists
  //       names.add(prod['Name'] ?? '');
  //       descriptions.add(prod['Description'] ?? '');
  //       links.add(prod['Link'] ?? '');
  //     }
  //     print('Names: $names');
  //     print('Descriptions: $descriptions');
  //     print('Links: $links');
  //   }
  //   setState(() {
  //     _buildFoodProfileSection(context);
  //   });
  // }

  int currentPage = 0;
  final PageController _page = PageController();

  @override
  Widget build(BuildContext context) {
    //  final accesstoken =Provider.of<AuthProvider>(context).accessToken;
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        drawer: UserDrawer(),
        body: PageView(
          controller: _page,
          onPageChanged: ((value) {
            setState(() {
              currentPage = value;
            });
          }),
          children: <Widget>[
            _buildUserHome(context),
            _buildStore(context),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: (page) {
            setState(() {
              currentPage = page;
              _page.animateToPage(
                page,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.houseChimneyMedical),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.store),
              label: 'Store',
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 60.h,
      leading: Builder(
        builder: (BuildContext builderContext) => AppbarLeadingImage(
          imagePath: ImageConstant.imgMegaphone,
          margin:
              EdgeInsets.only(left: 20.h, top: 20.v, right: 12.h, bottom: 20.v),
          onTap: () {
            Scaffold.of(builderContext).openDrawer();
          },
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 165.0),
          child: Text(
            "Meal Mate",
            style: theme.textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildUserHome(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(left: 9.h, top: 30.v, right: 18.h),
        decoration: BoxDecoration(
            color: appTheme.whiteA700,
            image: DecorationImage(
                image: AssetImage(ImageConstant.imgHome2), fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12.h),
              child: Text(
                "Hello,",
                style: CustomTextStyles.titleLargeBlack90003Regular,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.h),
              child: Text(
                name,
                style: theme.textTheme.headlineLarge,
              ),
            ),
            SizedBox(height: 30.v),
            Padding(
              padding: EdgeInsets.only(left: 12.h),
              child: Text(
                "My Booking",
                style: theme.textTheme.headlineSmall,
              ),
            ),
            SizedBox(height: 20.v),
            Padding(
              padding: EdgeInsets.only(left: 12.h),
              child: UserprofileItemWidget(
                onTapUserProfile: (selectedDoctorName) {
                  selectedDoctor = selectedDoctorName!;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          UserPrescriptionScreen(routine: routine)));
                },
                doctorName: ('Diet plan by ' + docname),
              ),
            ),
            SizedBox(height: 30.v),
            Padding(
              padding: EdgeInsets.only(left: 12.h),
              child: Text(
                "Dietitians",
                style: theme.textTheme.headlineSmall,
              ),
            ),
            SizedBox(height: 20.v),
            _buildDietitiansProfile(context),
            SizedBox(height: 30.v),
          ],
        ),
      ),
    );
  }

  Widget _buildStore(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: appTheme.whiteA700,
          image: DecorationImage(
              image: AssetImage(ImageConstant.imgHome2), fit: BoxFit.cover)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.v),
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.only(right: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 328.h,
                        margin: EdgeInsets.only(right: 13.h),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 30.v),
                                  Text(
                                    'Everything you need for ',
                                    style: theme.textTheme.headlineLarge,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 30.v),
                                  Text(
                                    'your ',
                                    style: theme.textTheme.headlineLarge,
                                  ),
                                  Text(
                                    goal,
                                    style:
                                        theme.textTheme.headlineLarge!.copyWith(
                                      color: appTheme.green500,
                                    ),
                                  ),
                                  Text(
                                    ' journey',
                                    style: theme.textTheme.headlineLarge,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.v),
                            ],
                          ),
                        )),
                    _buildFoodProfileSection(context),
                    // ElevatedButton(
                    //     // onPressed: getProducts, child: Text('Click here')
                    //     )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodProfileSection(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.only(left: 18.0, bottom: 30.v),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 235.v,
          crossAxisCount: 2,
          mainAxisSpacing: 18.h,
        ),
        physics: BouncingScrollPhysics(),
        // itemCount: names.length, // Use the length of the lists
        itemCount: 3, // Use the length of the lists
        itemBuilder: (context, index) {
          return UserprofilesectionItemWidget(
            index: index,
            id: index.toString(),
            // name: names[index], // Use the data from the lists
            name: ("Random text"), // Use the data from the lists
            // description: descriptions[index],
            description: ("Random description"),
            // link: links[index],
            link: ("Random Text"),
          );
        },
      ),
    );
  }

  Widget _buildDietitiansProfile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.h),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: 15.v);
        },
        itemCount: doctors.length,
        // itemCount: doctors.length,
        itemBuilder: (context, index) {
          // print(doctors[index]);
          return UserprofileItemWidgetNew(
            // return UserprofileItemWidget(
            onTapUserProfile: (selectedDoctorName, selectedDoctorId) {
              selectedDoctor = selectedDoctorName!;
              selectedDoctorId = selectedDoctorId!;
              print('selected Doctor Id and name');
              print(selectedDoctorId);
              // print(selectedDoctor);
              // Navigator.pushNamed(context,  AppRoutes.doctorDetailsScreenId.replaceAll(':id','3'));
              // Navigator.pushNamed(context, AppRoutes.doctorDetailsScreenId,
              //     arguments: {'doctorId': selectedDoctorId});

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailsScreenId(
                      doctorId: selectedDoctorId.toString()),
                ),
              );
              //  arguments: '3'

              // Navigator.pushNamed(context, AppRoutes.doctorDetailsScreen);
            },
            // doctorName: 'Charissa',
            doctorName: doctors[index]['first_name'],
            doctorID: doctors[index]['id'],
          );
        },
      ),
    );
  }
}
