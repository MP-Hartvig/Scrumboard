import 'package:localstore/localstore.dart';
import 'package:scrumboard/model/scrum_card.dart';

class ScrumCardLocalDataHandler {
  Future<List<ScrumCard>> getScrumCardLocalCollection() async {
    List<ScrumCard> tempCollection = [];
    final db = Localstore.instance;

    final items = await db.collection('ScrumCard').get();
    if (items != null) {
      for (var i = 0; i < items.length; i++) {
        tempCollection.add(ScrumCard.fromJson(items[i]));
      }
    }
    return tempCollection;
  }

  Future<ScrumCard> upsertScrumCardLocal(ScrumCard scrumCard) async {
    final db = Localstore.instance;

    // // Null check on id value, gets a new id if none was supplied
    // id = scrumCard.id ?? db.collection('ScrumCard').doc().id;

    // Saves a local copy with the id from the created object
    db.collection('ScrumCard').doc(scrumCard.id).set(scrumCard.toMap());

    final data = await db.collection('ScrumCard').doc(scrumCard.id).get();

    if (data == null) {
      throw Exception('[ERROR] Failed to get from local storage');
    }
    
    return ScrumCard.fromJson(data);
  }

  Future<void> deleteScrumCardLocalCollection() async {
    final db = Localstore.instance;
    db.collection("ScrumCard").delete();
  }

  
}
