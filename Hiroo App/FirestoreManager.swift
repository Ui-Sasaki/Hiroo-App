//
//  FirestoreManager.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/05/14.
//

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()

    func insertMissingPerson(_ person: MissingPersonViewController.MissingPerson, completion: @escaping (Bool) -> Void) {
        db.collection("missing_persons").document(person.documentID).setData([
            "name": person.name,
            "age": person.age,
            "clothes": person.clothes,
            "last_seen": person.lastSeenLocation,
            "reported_by": person.reportedBy,
            "timestamp": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("迷子情報の保存失敗: \(error.localizedDescription)")
                completion(false)
            } else {
                print("迷子情報の保存成功")
                completion(true)
            }
        }
    }
}
