import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:pwot/models/image.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/pages/contact_us/widget/d_add_therapist.dart';
import 'package:pwot/pages/contact_us/widget/m_add_therapist.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:flash/flash.dart';
import 'package:firebase/firebase.dart' as FB;
import 'dart:html' as HTML;


class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  HTML.File? file;
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
        child: loader ? Center(child: CircularProgressIndicator(color: AppColor.yellow,),): Container(
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
                      padding: EdgeInsets.symmetric(horizontal: 100),
                        itemBuilder: (_, i) {
                          return Card(
                            elevation: 5,
                            shadowColor: AppColor.bgSideMenu,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: AppColor.white,),
                              height: 300,
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
                                        height: double.infinity,
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
                                          SizedBox(height: 25,),
                                          Text("Name", style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text(therapists[i].name),
                                          SizedBox(height: 15,),
                                          Text("Contact", style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text(therapists[i].contact),
                                          Row(
                                            children: [
                                              SizedBox(width: 10,),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(vertical: 35),
                                                  decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                      color: AppColor.yellow
                                                  ),
                                                  child: MaterialButton(
                                                    highlightColor: Colors.transparent,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.find_in_page_outlined),
                                                        Text(" Select Image"),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      HTML.FileUploadInputElement picker = HTML.FileUploadInputElement()..accept = 'image/*';
                                                      picker.click();

                                                      picker.onChange.listen((event) {
                                                        setState(() {
                                                          file = picker.files?.first;
                                                        });
                                                        context.showSuccessBar(
                                                            content: Row(
                                                              children: [
                                                                const Text("Image selected successfully - "),
                                                                Text(file!.name, style: const TextStyle(fontWeight: FontWeight.bold),),
                                                              ],
                                                            ),
                                                            duration: Duration(seconds: 5)
                                                        );
                                                        final reader = HTML.FileReader();
                                                        reader.readAsDataUrl(file!);
                                                        reader.onLoadEnd.listen((event) {

                                                        });
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(vertical: 35),
                                                  decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                      color: Colors.red.shade900
                                                  ),
                                                  child: MaterialButton(
                                                    highlightColor: Colors.transparent,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.upload_file),
                                                        Text(" Upload"),
                                                      ],
                                                    ),
                                                    onPressed: () async {
                                                      if (file == null) {
                                                        context.showErrorBar(content: Text("Pick an Image"));
                                                        return;
                                                      }
                                                      if (therapists[i].uid != FirebaseAuth.instance.currentUser!.uid) {
                                                        context.showErrorBar(content: Text("You can only change your image"));
                                                        return;
                                                      }
                                                      setState(() {
                                                        loader = true;
                                                      });
                                                      CollectionReference users = FirebaseFirestore.instance.collection('users');
                                                      String link = "";
                                                      final datTime = DateTime.now().toIso8601String();
                                                      final userID = FirebaseAuth.instance.currentUser?.uid;
                                                      final path = '$userID/$datTime';
                                                      FB.UploadTaskSnapshot task = await FB.storage().refFromURL('gs://wilvcdn2021.appspot.com').child(path).put(file).future;
                                                      Uri uri = await task.ref.getDownloadURL();
                                                      link = uri.toString();
                                                      PostImage image = PostImage(id: task.ref.name, url: link);
                                                      users.doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                        'pic': image.url,
                                                      }).then((value) {
                                                        List<UserModel> users = [];
                                                        FirebaseFirestore.instance.collection('users').get().then((value) {
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
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                            ],
                                          )
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

  //this method only upload the image and get the image download url
  Future<PostImage> uploadImage() async {
    String link = "";
    final datTime = DateTime.now().toIso8601String();
    final userID = FirebaseAuth.instance.currentUser?.uid;
    final path = '$userID/$datTime';
    FB.UploadTaskSnapshot task = await FB.storage().refFromURL('gs://wilvcdn2021.appspot.com').child(path).put(file).future;
    Uri uri = await task.ref.getDownloadURL();
    link = uri.toString();
    PostImage image = PostImage(id: task.ref.name, url: link);
    return image;
  }

  Future<bool> uploadPost(String email, String password, String name, String contact, String link) async {
    bool task = false;
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    User? user = FirebaseAuth.instance.currentUser;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;

      //once user has been registered
      usersRef.doc(user!.uid).set({
        'uid': user.uid,
        'admin': true,
        'contact': contact,
        'pic': link,
        'name': name
      });
      await user.updateDisplayName(name);
      task = true;
    }  on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        context.showErrorBar(content: Text("The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        context.showErrorBar(content: Text("The account already exists for that email."));
      }
      return task;
    } catch (e) {
      print(e);
    }

    return task;
  }
}
