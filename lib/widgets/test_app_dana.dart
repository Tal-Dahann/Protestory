// class TestAppDana extends StatelessWidget {
//   const TestAppDana({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: context.read<DataProvider>().getMostRecentProtests(n: 5),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//               child: Text(snapshot.error.toString(),
//                   textDirection: TextDirection.ltr));
//         }
//         if (snapshot.hasData) {
//           return ProtestListHome(
//               protestList: snapshot.requireData, maxLengthList: 5);
//         }
//
//         //TODO: replace with waiting to list to load
//         return const CircularProgressIndicator();
//       },
//     );
//
//     //ProtestListHome(protestList: pl, maxLengthList: 5);
//   }
// }

// class TestAppDana extends StatelessWidget {
//   const TestAppDana({required DataProvider dt, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FirestoreSearchScaffold(
//       dataListFromSnapshot: dt,
//       firestoreCollectionName: 'users',
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return const Center(
//             child: Text('Snapshot has data'),
//           );
//         } else if (snapshot.hasError) {
//           return const Center(
//             child: Text('Snapshot has data'),
//           );
//         }
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//
//     //ProtestListHome(protestList: pl, maxLengthList: 5);
//   }
// }
