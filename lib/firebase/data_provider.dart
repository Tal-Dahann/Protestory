import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protestory/firebase/protest.dart';

class DataProvider {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference<Protest> protestCollectionRef ;

  DataProvider(){
    protestCollectionRef =  _firestore.collection("protests").withConverter(
      fromFirestore: Protest.fromFirestore,
      toFirestore: (Protest protest, _) => protest.toFirestore(),);
  }


  Future<Protest> addProtest(Protest protest) async {
    var docRef = await protestCollectionRef.add(protest);
    protest.id = docRef.id;
    return protest;
  }




}


