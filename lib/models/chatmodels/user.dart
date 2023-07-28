import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? nickname;
  final String? profileImageUrl;

  User(
    {
      this.nickname,
      this.profileImageUrl,
    }
  );

  factory User.fromDocumentSnapshot({required DocumentSnapshot<Map<String,dynamic>> doc})
  {
    return User(
      nickname : doc.data()?.containsKey('nickname')==false?'':doc["nickname"].toString(),
      profileImageUrl : doc.data()?.containsKey('profile_image_url')==false?'':doc["profile_image_url"].toString(),
    );
  }

}