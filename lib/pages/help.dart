import 'dart:async';

import 'package:accordion/accordion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwot/models/faqsModel.dart';
import 'package:pwot/services/faq_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash/flash.dart';
import 'package:pwot/widgets/add-faq.dart';
import 'package:flash/flash.dart';



class Help extends StatefulWidget {
  const Help({Key? key,}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  bool loader = false;
  bool helperLoader = false;
  late List<AccordionSection> accordionSection = [];

  @override
  void initState() {
    setState(() {
      loader = true;
    });
    FAQServices.extractAllFAQs().then((value) {
      int counter = 0;

      for (int i=0; i<value.length; i++){
        counter++;
        accordionSection.add(
          AccordionSection(
              headerBackgroundColor: AppColor.bgSideMenu,
              contentBorderColor: AppColor.bgSideMenu,
              isOpen: false,
              header: Text(value[i].question, style: const TextStyle(color: Colors.white, fontSize: 17)),
              content: helperLoader == true ? const SizedBox(child: Center(child: CircularProgressIndicator(),), height: 50,): Column(
                children: [
                  Text(value[i].answer, style: const TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Did you find this answer helpful?"),
                      const SizedBox(width: 5,),
                      MaterialButton(
                        onPressed: () async {
                          CollectionReference postCollection = FirebaseFirestore.instance.collection('faqs');
                          value[i].helpful++;
                          postCollection.doc(value[i].id).update(value[i].toJson()).then((value) {
                            context.showSuccessBar(content: Row(
                              children: const [
                                Text("FAQ marked as - "),
                                Text("Helpful", style: TextStyle(fontWeight: FontWeight.bold),),
                              ],
                            ));
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.thumb_up, color: Colors.green.shade900, size: 16,),
                            const SizedBox(width: 5,),
                            Text('Helpful ', style: TextStyle(
                                color: Colors.green.shade900
                            )
                            ),
                          ],
                        ),
                        textColor: Colors.green.shade900,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.green.shade900,
                            width: 1,
                            style: BorderStyle.solid
                        ), borderRadius: BorderRadius.circular(5)),
                      ),
                      const SizedBox(width: 5,),
                      MaterialButton(
                        onPressed: () async {
                          context.showSuccessBar(content: Row(
                            children: const [
                              Text("FAQ marked as - "),
                              Text("Not Helpful", style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ));
                          CollectionReference postCollection = FirebaseFirestore.instance.collection('faqs');
                          value[i].notHelpful++;
                          postCollection.doc(value[i].id).update(value[i].toJson()).then((value) {
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.thumb_down, color: Colors.red.shade900, size: 16,),
                            const SizedBox(width: 5,),
                            Text('Not Helpful ', style: TextStyle(
                                color: Colors.red.shade900
                            )
                            ),
                          ],
                        ),
                        textColor: Colors.red.shade900,
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.red.shade900,
                            width: 1,
                            style: BorderStyle.solid
                        ), borderRadius: BorderRadius.circular(5)),
                      )

                    ],
                  )
                ],
              )
          ),
        );
      }

      if (counter == value.length) {
        setState(() {
          loader = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: AppColor.bgSideMenu,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: AppColor.bgColor,
          ),
          child: loader == true ? Center(child: CircularProgressIndicator(color: AppColor.bgSideMenu,),): Column(
            children: [
              const SizedBox(height: 50,),
              const Text("Frequently Asked Questions.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              Accordion(
                maxOpenSections: 2,
                leftIcon: const Icon(Icons.question_answer_outlined, color: Colors.white),
                children: accordionSection
              ),
            ]
        ),
      )
    ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: AppColor.bgColor,),
        backgroundColor: AppColor.yellow,
        onPressed: () {
          Completer completer = Completer();
          context.showFlashDialog(
            dismissCompleter: completer,
            barrierDismissible: false,
            backgroundColor: AppColor.bgColor,
            margin: EdgeInsets.symmetric(horizontal: width * 0.2),
            persistent: true,
            title: const Text("Add a new FAQ"),
            content: AddFAQ(completer: completer,),
          );
        },
      ),
    );
  }

  // void refreshUIAfterFAQAdd() async {
  //   setState(() {
  //     loader = true;
  //   });
  //   List<FAQsModel> list = await FAQServices.extractAllFAQs();
  //   faqs = list;
  //   setState(() {
  //     loader = false;
  //   });
  //
  // }
}
