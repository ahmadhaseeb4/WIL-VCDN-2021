import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pwot/models/faqsModel.dart';

class FAQServices {

  static Future<bool> addFAQ(String q, String a) async {
    bool result = false;
    CollectionReference faqCollection = FirebaseFirestore.instance.collection('faqs');
    FAQsModel faq = FAQsModel(
        id: "NA",
        userID: FirebaseAuth.instance.currentUser!.uid,
        question: q,
        answer: a,
        helpful: 0,
        notHelpful: 0
    );
    await faqCollection.add(faq.toJson()).then((value) {
      result = true;
    });

    return result;
  }
  
  static Future<List<FAQsModel>> extractAllFAQs() async {
    List<FAQsModel> faqs = [];
    await FirebaseFirestore.instance.collection("faqs").get().then((value) {
      value.docs.forEach((element) {
        FAQsModel faq = FAQsModel.fromJson(element.data());
        faq.id = element.id;
        faqs.add(faq);
      });
    });
    return faqs;
  }
}