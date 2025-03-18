// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class SplasScreen extends StatefulWidget {
//   const SplasScreen({super.key});

//   @override
//   State<SplasScreen> createState() => _SplasScreenState();
// }

// class _SplasScreenState extends State<SplasScreen>
//     with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

//     Future.delayed(Duration(seconds: 2), () {
//       Navigator.of(
//         context,
//       ).pushReplacement(MaterialPageRoute(builder: (_) => OnboardingScreen()));
//     });
//   }

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.manual,
//       overlays: SystemUiOverlay.values,
//     );

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(colors: [Color.fromARGB(255, 107, 101, 43), Color.fromARGB(255, 37, 155, 41)]),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/fitur.png'),
//             SizedBox(height: 20),
//             Text(
//               'OKE GAS',
//               style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 color: Colors.white,
//                 fontSize: 35,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
