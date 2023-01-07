import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string_generator/random_string_generator.dart';

final _auth = FirebaseAuth.instance;
String? email = _auth.currentUser!.email;

class DatabaseServices {
  var childID = RandomStringGenerator(minLength: 5, maxLength: 10).generate();
  DatabaseServices({childID});
  setParentInformationData(name, bool isMale, avatarUrl) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      final newUser = db.collection('parents');
      await newUser.doc(email).set({
        "name": name,
        "isMale": isMale,
        "email": email,
        "avatar_url": avatarUrl
      });
    } catch (e) {
      print(e.toString());
    }
  }

  setChildInformationData(
      childName, childAge, relation, avatarUrl, level1, level2, level3) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      await db
          .collection('parents')
          .doc(email)
          .collection('children')
          .doc(childID)
          .set({
        "name": childName,
        "age": childAge,
        "relation": relation,
        "avatar_url": avatarUrl,
        "childID": childID,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  changeUserInformationData(name) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      final newUser = db.collection('parents');
      await newUser.doc("${_auth.currentUser!.email}").update({
        "name": name,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future lettersGameData() async {}
  Future wordsGameData() async {}
  Future storiesGameData() async {}
}
