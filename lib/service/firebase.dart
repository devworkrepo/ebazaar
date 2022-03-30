import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spayindia/model/app_update.dart';

const String _collectionName = "app_update";

class FirebaseService {
  static Future<InAppUpdateData> fetchInAppUpdateData() async {
    var reference = _getDocument(_InAppUpdateDocument.name);
    var inAppUpdateRef = reference.withConverter<InAppUpdateData>(
        fromFirestore: (snapshots, _) =>
            InAppUpdateData.fromJson(snapshots.data()),
        toFirestore: (inAppUpdate, _) => inAppUpdate.toJson());

    var inAppUpdateSnapshot = await inAppUpdateRef.get();
    return inAppUpdateSnapshot.data() ?? InAppUpdateData();
  }
}

DocumentReference _getDocument(String documentName) {
  DocumentReference reference =
      FirebaseFirestore.instance.collection(_collectionName).doc(documentName);
  return reference;
}

class _InAppUpdateDocument {
  static const name = "in_app_update";
  static const shouldUpdate = "should_update";
  static const forceUpdate = "force_update";
}
