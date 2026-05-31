// // lib/data/models/user_model.dart

// class UserModel {
//   final int id;
//   final String username;
//   final String email;
//   final String firstName;
//   final String lastName;
//   final String gender;
//   final String image;
//   final String accessToken;
//   final String refreshToken;

//   UserModel({
//     required this.id,
//     required this.username,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     required this.gender,
//     required this.image,
//     required this.accessToken,
//     required this.refreshToken,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'],
//       username: json['username'],
//       email: json['email'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       gender: json['gender'],
//       image: json['image'],
//       accessToken: json['accessToken'] ?? '', 
//       refreshToken: json['refreshToken'] ?? '',
//     );
//   }

//   // أضف هذه الدالة هنا لتعمل عملية الـ Save بنجاح
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'username': username,
//       'email': email,
//       'firstName': firstName,
//       'lastName': lastName,
//       'gender': gender,
//       'image': image,
//       'accessToken': accessToken,
//       'refreshToken': refreshToken,
//     };
//   }
// }

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? fcmToken; // توكن الإشعارات قد يكون فارغاً في البداية
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.fcmToken,
    this.createdAt,
  });

  // 1. تحويل البيانات من Map (قادمة من Firestore) إلى Object (داخل التطبيق)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      fcmToken: map['fcmToken'],
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as dynamic).toDate() 
          : null,
    );
  }

  // 2. تحويل الـ Object إلى Map لإرساله وتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'fcmToken': fcmToken,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }

  // 3. وظيفة اختيارية لتعديل بيانات معينة مع الحفاظ على البقية (State Management)
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? fcmToken,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}