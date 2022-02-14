// import 'package:flutter/material.dart';

// class BmiModel {
//   final String? id;
//   final double? height;
//   final double? weight;
//   final double? bmi;
//   final int? age;
//   final int? genderIndex;
//   final double? bmr;

//   BmiModel(
//       {this.id,
//       this.height,
//       this.weight,
//       this.age,
//       this.bmi,
//       this.bmr,
//       this.genderIndex});
//   copyWith(
//       {String? id,
//       double? height,
//       double? weight,
//       int? age,
//       double? bmi,
//       double? bmr,
//       int? genderIndex}) {
//     return BmiModel(
//         id: id ?? this.id,
//         weight: weight ?? this.weight,
//         height: height ?? this.height,
//         age: age ?? this.age,
//         bmi: bmi ?? this.bmi,
//         bmr: bmr ?? this.bmr,
//         genderIndex: genderIndex ?? this.genderIndex);
//   }

//   factory BmiModel.fromJson(Map<String, dynamic> json) {
//     return BmiModel(
//       id: json['id'] as String,
//       height: json['height'] as double,
//       genderIndex: json['genderIndex'] as int,
//       weight: json['weight'] as double,
//       bmi: json['bmi'] as double,
//       bmr: json['bmr'] as double,
//       age: json['age'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'height': height,
//       'weight': weight,
//       'bmi': bmi,
//       'bmr': bmr,
//       'age': age,
//       'genderIndex': genderIndex
//     };
//   }
// }

// // class BmiProvider extends ChangeNotifier {
// //   final List<BmiModel> _items = [];

// //   List<BmiModel> get items => _items;

// //   // BmiModel? bmiModel = BmiModel();

// //   // void updateBmiModel(
// //   //   double? height,
// //   //   double? weight,
// //   //   int? age,
// //   //   double? bmi,
// //   //   double? bmr,
// //   // ) {
// //   //   bmiModel = bmiModel?.copyWith(
// //   //       height: height, weight: weight, age: age, bmi: bmi, bmr: bmr);
// //   //   notifyListeners();
// //   // }
// // }
