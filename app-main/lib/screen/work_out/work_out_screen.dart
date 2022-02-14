// import 'package:app_flutter/provider.dart/calo_burn.dart';
// import 'package:app_flutter/screen/dash_board/dash_board_screen.dart';
// import 'package:app_flutter/screen/work_out/workout_list_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class WorkOutScreen extends StatefulWidget {
//   static const routeName = '/work-out';
//   const WorkOutScreen({Key? key}) : super(key: key);

//   @override
//   _WorkOutScreenState createState() => _WorkOutScreenState();
// }

// class _WorkOutScreenState extends State<WorkOutScreen> {
//   // late CaloBurn caloBurn;
//   double _run = 0;
//   double _cycle = 0;
//   @override
//   Widget build(BuildContext context) {
//     final caloBurnProvider =
//         Provider.of<CaloBurnProvider>(context, listen: false);
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Work Out Screen'),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   // setState(() {
//                   //   caloBurn = CaloBurn(
//                   //       runBurn: ((_run * 51) / 1000),
//                   //       cycleBurn: ((_cycle * 300) / 20000));
//                   // });
//                   caloBurnProvider.setRunBurn((_run * 51) / 1000);
//                   caloBurnProvider.setCycleBurn((_cycle * 300) / 20000);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const TabBarScreen()));
//                 },
//                 icon: const Icon(
//                   Icons.local_fire_department_outlined,
//                 ))
//           ],
//         ),
//         body: SingleChildScrollView(
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
//               child: Row(
//                 children: [
//                   Text('Activity',
//                       style: Theme.of(context).textTheme.headline3),
//                   const Spacer(),
//                   TextButton(
//                       onPressed: () {
//                         Navigator.pushNamed(
//                             context, WorkOutListSceen.routeName);
//                       },
//                       child: const Text('Show All'))
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Container(
//                 height: 160,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: const Color(0xff39439f),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: 15,
//                       left: 18,
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.directions_run_rounded,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                           const SizedBox(
//                             width: 6,
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text('running',
//                                   style: TextStyle(
//                                     color: Color(0xffc4bbcc),
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   )),
//                               Text(
//                                 '${_run.round()} m',
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: Container(
//                         padding: const EdgeInsets.only(left: 16, right: 16),
//                         child: Slider(
//                           min: 0,
//                           max: 20000,
//                           onChanged: (m) {
//                             setState(() {
//                               _run = m;
//                             });
//                           },
//                           value: _run,
//                           divisions: 100,
//                           activeColor: Colors.blue,
//                           label: "$_run",
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 20,
//                       left: 20,
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.local_fire_department_outlined,
//                             color: Colors.red,
//                             size: 30,
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             '${(_run.round() * 51) / 1000} ',
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20),
//                           ),
//                           const Text(
//                             ' kcal Burn',
//                             style: TextStyle(color: Color(0xffF3BBEC)),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Container(
//                 height: 160,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: const Color(0xff39439f),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: 15,
//                       left: 15,
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.directions_bike,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text('Cycling',
//                                   style: TextStyle(
//                                     color: Color(0xffc4bbcc),
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   )),
//                               Text(
//                                 '${_cycle.round()} m',
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: Container(
//                         padding: const EdgeInsets.only(left: 16, right: 16),
//                         child: Slider(
//                           min: 0,
//                           max: 100000,
//                           onChanged: (m) {
//                             setState(() {
//                               _cycle = m;
//                             });
//                           },
//                           value: _cycle,
//                           divisions: 100,
//                           activeColor: Colors.blue,
//                           label: "$_cycle",
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 20,
//                       left: 20,
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.local_fire_department_outlined,
//                             color: Colors.red,
//                             size: 30,
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             '${(_cycle.round() * 300) / 20000} ',
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20),
//                           ),
//                           const Text(
//                             ' kcal Burn',
//                             style: TextStyle(color: Color(0xffF3BBEC)),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ]),
//         ));
//   }
// }
