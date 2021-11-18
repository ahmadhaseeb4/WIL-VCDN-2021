import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/pages/contact_us/widget/d_add_therapist.dart';
import 'package:pwot/pages/contact_us/widget/m_add_therapist.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:flash/flash.dart';



class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool loader = false;
  List<UserModel> therapists = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      loader = true;
    });
    List<UserModel> users = [];
    FirebaseFirestore.instance.collection('users').get()
        .then((value) {
      value.docs.forEach((element) {
        users.add(UserModel.fromJson(element.data()));
      });
      users.forEach((element) {
        if (element.admin) {
          therapists.add(element);
        }
      });
      setState(() {
        loader = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: AppColor.bgSideMenu,
        child: loader ? Center(child: CircularProgressIndicator(color: AppColor.bgSideMenu,),): Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: AppColor.bgColor,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 150),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemBuilder: (_, i) {
                          return Card(
                            elevation: 5,
                            shadowColor: AppColor.bgSideMenu,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: AppColor.white,),
                              height: 200,
                              child: loader
                                  ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.yellow,
                                  ))
                                  : Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                        width: double.infinity,
                                        child: Card(
                                          color: AppColor.bgColor,
                                          elevation: 2,
                                          child: OctoImage(
                                            image: NetworkImage(therapists[i].pic),
                                            progressIndicatorBuilder: OctoProgressIndicator.circularProgressIndicator(),
                                            errorBuilder: OctoError.icon(color: Colors.red),
                                          ),
                                        ),
                                      ),
                                  ),
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Text("Name"),
                                          Text(therapists[i].name),
                                          SizedBox(height: 15,),
                                          Text("Contact"),
                                          Text(therapists[i].contact),
                                        ],
                                      ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }, itemCount: therapists.length,)
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add, color: AppColor.bgColor,),
      //   backgroundColor: Colors.red.shade900,
      //   onPressed: () {
      //     Completer completer = Completer();
      //     context.showFlashDialog(
      //       dismissCompleter: completer,
      //       barrierDismissible: false,
      //       backgroundColor: AppColor.bgColor,
      //       margin: EdgeInsets.symmetric(horizontal: 300),
      //       persistent: true,
      //       content: width < 850 ? MobileAddTherapist(): DesktopAddTherapist(completer: completer, refreshUI: updateTherapistList)
      //     );
      //   },
      // ),
    );
  }

  void updateTherapistList(List<UserModel> list) {
    setState(() {
      therapists = list;
    });
  }
}
