import '../../models/like.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikesRepository {
  var collection = FirebaseFirestore.instance
      .collection('users/' + FirebaseAuth.instance.currentUser!.uid + '/items');

  Stream<List<Like>> fetchItems() {
    return collection
        .orderBy('created', descending: true)
        .snapshots()
        .map((event) {
      var items = <Like>[];
      event.docs.forEach((doc) {
        items.add(
          Like(
            doc.data()['id'],
            doc.data()['url'],
            DateTime.fromMillisecondsSinceEpoch(doc.data()['created'],
                isUtc: true),
          ),
        );
      });
      return items;
    });
  }

  Future addLike(Like like) async {
    like.created = DateTime.now();

    await collection.doc(like.id).set({
      'id': like.id,
      'url': like.url,
      'created': like.created.toUtc().millisecondsSinceEpoch,
    });
  }

  Future<bool> likeExist(String id) async {
    final like = await collection.doc(id).get();
    if (like.exists) {
      return true;
    }
    return false;
  }

  Future dislike(String id) async {
    await collection.doc(id).delete();
  }
}
