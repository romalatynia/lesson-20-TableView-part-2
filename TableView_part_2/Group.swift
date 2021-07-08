//
//  Group.swift
//  TableView_part_2
//
//  Created by Harbros47 on 29.01.21.
//

import Foundation

class Group {
    var name: String
    var students: [Student]
    
    init(name: String, students: [Student]) {
        self.name = name
        self.students = students
    }
    
    static func createStudents(studentGroup: [Student]) -> [Student] {
        var group = studentGroup
        for _ in 0..<10 {
            let student = Student()
            student.randomStudents()
            group.append(student)
        }
        return group
    }
}
