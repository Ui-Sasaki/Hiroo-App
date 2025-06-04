import FirebaseFirestore

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()

    func insertMissingPerson(_ person: MissingPersonViewController.MissingPerson, completion: @escaping (Bool) -> Void) {
        db.collection("missing_persons").document(person.documentID).setData([
            "name": person.name,
            "age": person.age,
            "clothes": person.clothes,
            "last_seen_location": person.lastSeenLocation,
            "reported_by": person.reportedBy,
            "timestamp": Timestamp(date: Date())
        ]) { error in
            completion(error == nil)
        }
    }

    func insertFoundPerson(_ person: MissingPersonViewController.FoundPerson, completion: @escaping (Bool) -> Void) {
        db.collection("found_persons").document(person.documentID).setData([
            "name": person.name,
            "found_location": person.foundLocation,
            "timestamp": Timestamp(date: Date())
        ]) { error in
            completion(error == nil)
        }
    }
}

