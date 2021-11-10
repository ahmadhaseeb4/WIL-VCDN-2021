import 'dart:async';
import 'dart:html' as HTML;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pwot/models/faqsModel.dart';
import 'package:pwot/pages/auth/pages/auth.dart';
import 'package:pwot/pages/dashboard.dart';
import 'package:pwot/pages/feed.dart';
import 'package:pwot/pages/help.dart';
import 'package:pwot/services/faq_services.dart';
import 'package:pwot/services/post_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:flash/flash.dart';
import 'package:firebase/firebase.dart' as FB;
import 'package:pwot/widgets/add-post.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



import 'models/postModel.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
      home: MyHomePage(title: 'Playwrite Occupational Therapy'),
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
  List<FAQsModel> faqs = [];
  bool loader = false;
  String? name;

  @override
  void initState() {
    setState(() {
      loader = true;
    });
    FirebaseAuth.instance.authStateChanges().first.then((value1) {
      if (value1 != null){
        FAQServices.extractAllFAQs().then((value2) {
          currentUser = value1;
          faqs = value2;
          print("Total FAQS - ${value2.length}");
          setState(() {
            name = currentUser!.displayName;
            loader = false;
          });
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
              title: 'Dashboard',
              onTap: () {
                page.jumpToPage(1);
              },
              icon: Icons.dashboard,
            ),
            SideMenuItem(
              priority: 2,
              title: 'Messages',
              onTap: () {
                page.jumpToPage(2);
              },
              icon: Icons.message
            ),
            SideMenuItem(
              priority: 3,
              title: 'Help Centre',
              onTap: () {
                  page.jumpToPage(3);
              },
              icon: Icons.live_help_rounded,
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
                await FirebaseAuth.instance.signOut().then((value) {
                  currentUser = null;
                  setState(() {
                    name = "";
                  });
                  page.jumpToPage(0);
                });
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
              Feed(posts: posts,),
              Dashboard(),
              Dashboard(),
              Help(faqs: faqs,),
              Auth(pageController: page, refreshUI: refreshUI,),
            ],
          ),
        ),
      ],
    );
  }

  void refreshUI(User? user, String named) {
    currentUser = user;
    setState(() {
      name = named;
    });
  }

}

