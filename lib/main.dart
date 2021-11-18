import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pwot/pages/auth/pages/auth.dart';
import 'package:pwot/pages/feed/feed.dart';
import 'package:pwot/pages/help/help.dart';
import 'package:pwot/pages/contact_us/contact_us.dart';
import 'package:pwot/pages/profile/profile.dart';
import 'package:pwot/services/auth_services.dart';
import 'package:pwot/utility/app_colors.dart';


import 'models/postModel.dart';
import 'models/userModel.dart';

User? currentUser;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PWOT',
      theme: ThemeData.dark().copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
      home: const MyHomePage(title: 'Playwrite Occupational Therapy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserModel userModel = UserModel(uid: "null", admin: false, contact: "Not Available", pic: '', name: '');
  PageController page = PageController();
  List<PostModel> posts = [];
  bool loader = false;
  String? name;

  @override
  void initState() {
    setState(() {
      loader = true;
    });
    FirebaseAuth.instance.authStateChanges().first.then((value1) async {
      if (value1 != null) {
        await AuthServices.getUserModel(value1.uid).then((value) {
          if (value.admin == true) {
            userModel = value;
            currentUser = value1;
            setState(() {
              name = currentUser!.displayName;
              loader = false;
            });
          } else {
            userModel = value;
            currentUser = value1;
            setState(() {
              name = currentUser!.displayName;
              loader = false;
            });
          }
        });
      } else {
        print("Login error!");
        FirebaseAuth.instance.signOut();
      }
      setState(() {
        loader = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return loader == true ? Container(child: Center(child: CircularProgressIndicator(color: AppColor.bgSideMenu,),), color: AppColor.bgColor,):Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: AppColor.bgSideMenu,
      ),
      body: SideDrawer(width, height),
    );
  }

  Widget SideDrawer(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SideMenu(
          controller: page,
          style: SideMenuStyle(
              openSideMenuWidth: width * 0.2,
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: AppColor.white.withAlpha(100),
              selectedColor: AppColor.yellow,
              selectedTitleTextStyle: TextStyle(color: AppColor.white),
              unselectedTitleTextStyle: TextStyle(color: AppColor.white),
              selectedIconColor: AppColor.white,
              unselectedIconColor: AppColor.white,
              backgroundColor: AppColor.bgSideMenu
            // openSideMenuWidth: 200
          ),
          title: Column(
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: height,
                    maxWidth: width * 0.2,
                  ),
                  child: Image.network
                    ("https://firebasestorage.googleapis.com/v0/b/wilvcdn2021.appspot.com/o/Playwright(1).png?alt=media&token=43fee245-0d60-4d79-936f-e75a78f0365b"),
              ),
              const Divider(
                indent: 8.0,
                endIndent: 8.0,
              ),
            ],
          ),
          footer: Padding(
            padding: const EdgeInsets.all(8.0),
            child: name == null ? const Text(""): Text(name!, style: TextStyle(color: AppColor.yellow)),
          ),
          items: [
            SideMenuItem(
              priority: 0,
              title: 'Feed Page',
              onTap: () {
                page.jumpToPage(0);
              },
              icon: Icons.feed,
            ),
            SideMenuItem(
              priority: 1,
              title: 'Contact Us',
              onTap: () {
                page.jumpToPage(1);
              },
              icon: Icons.quick_contacts_dialer_sharp,
            ),
            SideMenuItem(
              priority: 2,
              title: 'Help Centre',
              onTap: () {
                  page.jumpToPage(2);
              },
              icon: Icons.live_help_rounded,
            ),
            if (FirebaseAuth.instance.currentUser != null)
            SideMenuItem(
              priority: 3,
              title: 'Profile',
              onTap: () {
                page.jumpToPage(3);
              },
              icon: Icons.supervisor_account_outlined,
            ),
            currentUser == null ?
            SideMenuItem(
              priority: 4,
              title: 'Sign In',
              onTap: () async {
                page.jumpToPage(4);
              },
              icon: Icons.login,
            ): SideMenuItem(
              priority: 4,
              title: 'Sign Out',
              onTap: () async {
                await logOut();
              },
              icon: Icons.cancel,
            ),
          ],
        ),
        Expanded(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: page,
            children: [
              Feed(data: posts,),
              ContactUs(),
              Help(userModel: userModel,),
              Profile(userModel: userModel, refreshUI: refreshUI, logOut: logOut,),
              Auth(pageController: page, refreshUI: refreshUI,),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      currentUser = null;
      setState(() {
        userModel = UserModel(uid: "null", admin: false, contact: "Not available", pic: '', name: '');
        name = "";
      });
      page.jumpToPage(4);
    });
  }

  void refreshUI(User? user) {
    setState(() {
      name = FirebaseAuth.instance.currentUser!.displayName!;
      currentUser = user;
    });

  }

}

