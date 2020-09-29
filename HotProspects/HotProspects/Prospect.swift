//
//  Prospect.swift
//  HotProspects
//
//  Created by Larry Nguyen on 9/27/20.
//

import SwiftUI

class Prospect: Identifiable, Codable, Comparable {
    
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var date = Date()
    fileprivate(set) var isContacted = false
    
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.name == rhs.name && lhs.emailAddress == rhs.emailAddress
    }
    
    static func < (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.name < rhs.name
    }
    
    static func sortDate (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.date < rhs.date
    }
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    static let saveKey = "SavedData"
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func sortByName() {
        self.people = people.sorted()
        save()
    }
    
    func sortByDate() {
        self.people = people.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func deleteProspect(_ prospect: Prospect) {
        if let index = people.firstIndex(of: prospect) {
            people.remove(at: index)
        }
        save()
    }
    
    func add(_ prospect: Prospect) {
        if !people.contains(prospect) {
            people.append(prospect)
            save()
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        }
        self.people = []
    }
}
