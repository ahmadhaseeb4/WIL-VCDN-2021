import 'dart:async';
import 'dart:html' as HTML;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pwot/pages/auth/pages/auth.dart';
import 'package:pwot/pages/dashboard.dart';
import 'package:pwot/pages/feed.dart';
import 'package:pwot/services/post_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:flash/flash.dart';
import 'package:firebase/firebase.dart' as FB;
import 'package:pwot/widgets/add-post.dart';

import 'models/postModel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
  PageController page = PageController();
  List<PostModel> posts = [];
  bool loader = false;
  bool clear = true;
  String storagePath = "null";
  Uri? fileDownloadURL;
  HTML.File? file;
  String? fileName;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: AppColor.bgSideMenu,
      ),
      body: SideDrawer(width, height),
    );
  }

  void pickImage() {
    HTML.FileUploadInputElement picker = HTML.FileUploadInputElement()..accept = 'image/*';
    picker.click();

    picker.onChange.listen((event) {
      file = picker.files?.first;

      final reader = HTML.FileReader();
      reader.readAsDataUrl(file!);
      reader.onLoadEnd.listen((event) {
        setState(() {
          fileName = file!.name;
        });
      });
    });
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
                    maxWidth: width * 0.01,
                  ),
                  child: Icon(Icons.image)
              ),
              Divider(
                indent: 8.0,
                endIndent: 8.0,
              ),
            ],
          ),
          footer: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${FirebaseAuth.instance.currentUser?.displayName}', style: TextStyle(color: AppColor.yellow)),
          ),
          items: [
            SideMenuItem(
              priority: 0,
              title: 'Feed Page',
              onTap: () {
                page.jumpToPage(0);
              },
              icon: Icons.supervisor_account,
            ),
            SideMenuItem(
              priority: 1,
              title: 'Dashboard',
              onTap: () {
                page.jumpToPage(1);
              },
              icon: Icons.home,
            ),
            SideMenuItem(
              priority: 2,
              title: 'Messages',
              onTap: () {
                page.jumpToPage(2);
              },
              icon: Icons.file_copy_rounded,
            ),
            SideMenuItem(
              priority: 3,
              title: 'Help',
              onTap: () {
                page.jumpToPage(3);
              },
              icon: Icons.file_copy_rounded,
            ),
            FirebaseAuth.instance.currentUser == null ?
            SideMenuItem(
              priority: 4,
              title: 'Sign In',
              onTap: () async {
                page.jumpToPage(4);
              },
              icon: Icons.exit_to_app,
            ): SideMenuItem(
              priority: 4,
              title: 'Sign Out',
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {});
                page.jumpToPage(1);
              },
              icon: Icons.exit_to_app,
            ),
          ],
        ),
        Expanded(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: page,
            children: [
              Feed(posts: posts,),
              Dashboard(),
              Dashboard(),
              Dashboard(),
              Auth(),
            ],
          ),
        ),
      ],
    );
  }


  //not used
  Future<bool> delete() async {
    bool status = false;
    FB.storage().refFromURL('gs://wilvcdn2021.appspot.com').child(storagePath).delete().then((value) {
      status = true;
    });

    return status;
  }
  
}

