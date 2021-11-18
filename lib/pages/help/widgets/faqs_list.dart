import 'package:accordion/accordion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwot/models/faqsModel.dart';
import 'package:pwot/models/userModel.dart';
import 'package:pwot/services/auth_services.dart';
import 'package:pwot/services/faq_services.dart';
import 'package:pwot/utility/app_colors.dart';
import 'package:flash/flash.dart';


class FAQsList extends StatefulWidget {
  const FAQsList({Key? key, required this.extractedFAQs, required this.resetArticlesUI}) : super(key: key);
  final List<FAQsModel> extractedFAQs;
  final Function resetArticlesUI;

  @override
  _FAQsListState createState() => _FAQsListState();
}

class _FAQsListState extends State<FAQsList> {
  late List<AccordionSection> accordionSection = [];
  bool loader = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        loader = true;
      });
      AuthServices.getUserModel(FirebaseAuth.instance.currentUser!.uid).then((value) {
        user = value;
        for (int i = 0; i < widget.extractedFAQs.length; i++) {
          accordionSection.add(
            AccordionSection(
                headerBackgroundColor: AppColor.bgSideMenu,
                contentBorderColor: AppColor.bgSideMenu,
                isOpen: false,
                header: Text(widget.extractedFAQs[i].question,
                    style: const TextStyle(color: Colors.white, fontSize: 17)),
                content: Column(
                  children: [
                    Text(
                      widget.extractedFAQs[i].answer,
                      style: const TextStyle(fontWeight: FontWeight.bold,),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Did you find this answer helpful?"),
                        const SizedBox(
                          width: 5,
                        ),
                        MaterialButton(
                          onPressed: () async {
                            CollectionReference postCollection = FirebaseFirestore.instance.collection('faqs');
                            widget.extractedFAQs[i].helpful++;
                            postCollection.doc(widget.extractedFAQs[i].id).update(widget.extractedFAQs[i].toJson()).then((value) {
                              context.showSuccessBar(
                                  content: Row(
                                    children: const [
                                      Text("FAQ marked as - "),
                                      Text(
                                        "Helpful",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ));
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.thumb_up,
                                color: Colors.green.shade900,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text('Helpful ',
                                  style: TextStyle(
                                      color: Colors.green.shade900)),
                            ],
                          ),
                          textColor: Colors.green.shade900,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.green.shade900,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        MaterialButton(
                          onPressed: () async {
                            context.showSuccessBar(
                                content: Row(
                                  children: const [
                                    Text("FAQ marked as - "),
                                    Text(
                                      "Not Helpful",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ));
                            CollectionReference postCollection =
                            FirebaseFirestore.instance
                                .collection('faqs');
                            widget.extractedFAQs[i].notHelpful++;
                            postCollection
                                .doc(widget.extractedFAQs[i].id)
                                .update(widget.extractedFAQs[i].toJson())
                                .then((value) {});
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.thumb_down,
                                color: Colors.red.shade900,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text('Not Helpful ',
                                  style: TextStyle(
                                      color: Colors.red.shade900)),
                            ],
                          ),
                          textColor: Colors.red.shade900,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.red.shade900,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(width: 5,),
                        if (user != null && user!.admin) InkWell(
                          child: Icon(
                            Icons.delete,
                            color: Colors.red.shade900,
                          ),
                          onTap: () async {
                            setState(() {
                              accordionSection.removeAt(i);
                              loader = true;
                            });
                            List<FAQsModel> data = await FAQServices.deleteFAQ(widget.extractedFAQs[i].id);
                            widget.extractedFAQs.clear();
                            data.forEach((element) {
                              widget.extractedFAQs.add(element);
                            });
                            setState(() {
                              loader = false;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                )),
          );
        }
        setState(() {
          loader = false;
        });
      });
    } else {
      for (int i = 0; i < widget.extractedFAQs.length; i++) {
        accordionSection.add(
          AccordionSection(
              headerBackgroundColor: AppColor.bgSideMenu,
              contentBorderColor: AppColor.bgSideMenu,
              isOpen: false,
              header: Text(widget.extractedFAQs[i].question,
                  style: const TextStyle(color: Colors.white, fontSize: 17)),
              content: Column(
                children: [
                  Text(
                    widget.extractedFAQs[i].answer,
                    style: const TextStyle(fontWeight: FontWeight.bold,),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Did you find this answer helpful?"),
                      const SizedBox(
                        width: 5,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          CollectionReference postCollection = FirebaseFirestore.instance.collection('faqs');
                          widget.extractedFAQs[i].helpful++;
                          postCollection.doc(widget.extractedFAQs[i].id).update(widget.extractedFAQs[i].toJson()).then((value) {
                            context.showSuccessBar(
                                content: Row(
                                  children: const [
                                    Text("FAQ marked as - "),
                                    Text(
                                      "Helpful",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ));
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.thumb_up,
                              color: Colors.green.shade900,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text('Helpful ',
                                style: TextStyle(
                                    color: Colors.green.shade900)),
                          ],
                        ),
                        textColor: Colors.green.shade900,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.green.shade900,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          context.showSuccessBar(
                              content: Row(
                                children: const [
                                  Text("FAQ marked as - "),
                                  Text(
                                    "Not Helpful",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ));
                          CollectionReference postCollection =
                          FirebaseFirestore.instance
                              .collection('faqs');
                          widget.extractedFAQs[i].notHelpful++;
                          postCollection
                              .doc(widget.extractedFAQs[i].id)
                              .update(widget.extractedFAQs[i].toJson())
                              .then((value) {});
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.thumb_down,
                              color: Colors.red.shade900,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text('Not Helpful ',
                                style: TextStyle(
                                    color: Colors.red.shade900)),
                          ],
                        ),
                        textColor: Colors.red.shade900,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.red.shade900,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      const SizedBox(width: 5,),
                    ],
                  )
                ],
              )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loader
        ? Center(child: CircularProgressIndicator(color: AppColor.yellow,),)
        : Accordion(
        maxOpenSections: 2,
        leftIcon: const Icon(
            Icons.question_answer_outlined,
            color: Colors.white),
        children: accordionSection
    );
  }


}
