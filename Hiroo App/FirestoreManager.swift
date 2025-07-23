//
//  FirestoreManager.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/05/14.
//
import UIKit
import FirebaseFirestore

struct Event {
    let id: String
    let name: String
    let location: String
    let congestion: Int
    let type: String
    let startTime: Date
    let endTime: Date
}

final class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    private init() {}
    
    func fetchevents(for school: School,
                     completion: @escaping (Result<[Event], Error>) -> Void) {
        let ref = db
            .collection("schools")
            .document(school.rawValue)
            .collection("events")
        
        ref.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error)); return
            }
            let docs = snapshot?.documents ?? []
            let events = docs.compactMap { doc -> Event? in
                let data = doc.data()
                guard
                    let name = data["name"] as? String,
                    let location = data["location"] as? String,
                    let congestion = data["congestion"] as? Int,
                    let type = data["type"] as? String,
                    let startTime = data["start_time"] as? Date,
                    let endTime = data["end_time"] as? Date
                else { return nil }
                return Event(
                    id: doc.documentID,
                    name: name,
                    location: location,
                    congestion: congestion,
                    type: type,
                    startTime: startTime,
                    endTime: endTime
                )
            }
            completion(. success(events))
        }
        }
        func fetchboothevents(for school: School,
                              completion: @escaping (Result<[Event], Error>) -> Void) {
            let ref = db
                .collection("schools")
                .document(school.rawValue)
                .collection("events")
                .whereField("type", isEqualTo: "booth")
            
            ref.getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error)); return
                }
                let docs = snapshot?.documents ?? []
                let events = docs.compactMap { doc -> Event? in
                    let data = doc.data()
                    guard
                        let name = data["name"] as? String,
                        let location = data["location"] as? String,
                        let congestion = data["congestion"] as? Int,
                        let type = data["type"] as? String,
                        let startTime = data["start_time"] as? Date,
                        let endTime = data["end_time"] as? Date
                    else { return nil }
                    return Event(
                        id: doc.documentID,
                        name: name,
                        location: location,
                        congestion: congestion,
                        type: type,
                        startTime: startTime,
                        endTime: endTime
                    )
                }
                completion(. success(events))
        }
    }
//    func fetchstageevents(for school: School,
//                          completion: @escaping (Result<[Event], Error>) -> Void) {
//        let ref = db
//            .collection("schools")
//            .document(school.rawValue)
//            .collection("events")
//            .whereField("type", isEqualTo: "stage")
//
//        ref.getDocuments { snapshot, error in
//            if let error = error {
//                completion(.failure(error)); return
//            }
//            let docs = snapshot?.documents ?? []
//            let events = docs.compactMap { doc -> Event? in
//                let data = doc.data()
//                guard
//                    let name = data["name"] as? String,
//                    let location = data["location"] as? String,
//                    let congestion = data["congestion"] as? Int,
//                    let type = data["type"] as? String,
//                    let startTime = data["start_time"] as? Date,
//                    let endTime = data["end_time"] as? Date
//                else { return nil }
//                return Event(
//                    id: doc.documentID,
//                    name: name,
//                    location: location,
//                    congestion: congestion,
//                    type: type,
//                    startTime: startTime,
//                    endTime: endTime
//                )
//            }
//            completion(. success(events))
//    }
//}
}
            //class FirestoreManager {
            //    static let shared = FirestoreManager()
            //    private let db = Firestore.firestore()
            //
            //    func insertMissingPerson(_ person: MissingPersonViewController.MissingPerson, completion: @escaping (Bool) -> Void) {
            //        db.collection("missing_persons").document(person.documentID).setData([
            //            "name": person.name,
            //            "age": person.age,
            //            "clothes": person.clothes,
            //            "last_seen_location": person.lastSeenLocation,
            //            "reported_by": person.reportedBy,
            //            "timestamp": Timestamp(date: Date())
            //        ]) { error in
            //            completion(error == nil)
            //        }
            //    }
            //
            //    func insertFoundPerson(_ person: MissingPersonViewController.FoundPerson, completion: @escaping (Bool) -> Void) {
            //        db.collection("found_persons").document(person.documentID).setData([
            //            "name": person.name,
            //            "found_location": person.foundLocation,
            //            "timestamp": Timestamp(date: Date())
            //        ]) { error in
            //            completion(error == nil)
            //        }
            //    }
            //}
            //
            

