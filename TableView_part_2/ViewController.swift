//
//  ViewController.swift
//  TableView_part_2
//
//  Created by Harbros47 on 29.01.21.
//

import UIKit

private enum Constants {
    static let indentifire = "MyCell"
    static let identNewEmployee = "indentifierAddEmployee"
    static let countOfAdditionalRows = 1
    static let indexRowForAddButton = 0
    static let add = "Add New Row"
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var editButton: UIBarButtonItem!
    private var addButton: UIBarButtonItem!
    private var myTableView = UITableView()
    private var studentArray = [Group]()
    private var studentArrayGroupA = [Student]()
    private var studentArrayGroupB = [Student]()
    private var studentArrayGroupC = [Student]()
    private var studentArrayGroupD = [Student]()
    private var studentArrayGroupF = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentArray = [
            Group(name: "Group A", students: Group.createStudents(studentGroup: studentArrayGroupA)),
            Group(name: "Group B", students: Group.createStudents(studentGroup: studentArrayGroupB)),
            Group(name: "Group C", students: Group.createStudents(studentGroup: studentArrayGroupC)),
            Group(name: "Group D", students: Group.createStudents(studentGroup: studentArrayGroupD)),
            Group(name: "Group F", students: Group.createStudents(studentGroup: studentArrayGroupF))
        ]
        createTable()
        createRightAndLeftBarButtonsItems()
    }
    
    // MARK: - создание таблицы и добавленние её на View
    func createTable() {
        myTableView = UITableView(frame: view.bounds, style: .plain)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.indentifire)
        myTableView.delegate = self
        myTableView.dataSource = self
        
        view.addSubview(myTableView)
    }
    
    // MARK: - количесво секций
    func numberOfSections(in tableView: UITableView) -> Int {
        studentArray.count
    }
    
    // MARK: - имена титульников
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        studentArray[section].name
    }
    
    // MARK: - количесво ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studentArray[section].students.count + Constants.countOfAdditionalRows
    }
    
    // MARK: - создание ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == Constants.indexRowForAddButton {
            var cell = tableView.dequeueReusableCell(withIdentifier: Constants.identNewEmployee)
            cell = cell ?? UITableViewCell(style: .default, reuseIdentifier: Constants.identNewEmployee)
            cell?.textLabel?.text = Constants.add
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.textColor = .blue
            
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.indentifire, for: indexPath)
            let studentSection = studentArray[indexPath.section].students
            let student = studentSection[indexPath.row - Constants.countOfAdditionalRows]
            cell.textLabel?.text = "\(student.firstName)  \(student.lastName)"
            cell.accessoryType = .none
            
            return cell
        }
    }
    
    // MARK: - перетаскивание ячеек
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        indexPath.row > Constants.indexRowForAddButton
    }
    
    func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        let removedEmployee = studentArray[sourceIndexPath.section].students
            .remove(at: sourceIndexPath.row - Constants.countOfAdditionalRows)
        studentArray[destinationIndexPath.section].students
            .insert(removedEmployee, at: destinationIndexPath.row - Constants.countOfAdditionalRows)
        
    }
    
    // MARK: - добавление новых ячеек
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = Student()
        student.randomStudents()
        let newStudent = student
        guard indexPath.row == Constants.indexRowForAddButton else { return }
        let studentRow = studentArray[indexPath.section]
        studentRow.students.insert(newStudent, at: Constants.indexRowForAddButton)
        tableView.insertRows(
            at: [IndexPath(
                row: Constants.countOfAdditionalRows,
                section: indexPath.section
            )
            ],
            with: .left
        )
    }
    
    // MARK: - удаление ячеек
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }
        studentArray[indexPath.section].students.remove(at: indexPath.row - Constants.countOfAdditionalRows)
        
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.reloadData()
    }
    
    // MARK: - созжание кнопок "Add" и "Edit"
    private func createRightAndLeftBarButtonsItems() {
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(actionEdit))
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSectionAction))
        navigationItem.rightBarButtonItem = editButton
        navigationItem.leftBarButtonItem = addButton
    }
      
    // MARK: - кнопока "Add" добавление новых групп
    @objc private func addSectionAction() {
        
        guard !myTableView.isEditing else { return }
        let newGroup = Group(name: "Group", students: [Student]())
        studentArray.insert(newGroup, at: Constants.indexRowForAddButton)
        let insertIndex = NSIndexSet(index: Constants.indexRowForAddButton) as IndexSet
        myTableView.insertSections(insertIndex, with: .left)
    }
    
    // MARK: - кнопока "Edit" редактирование ячеек(удаление, перемещение). Кнопка "done"
    @objc private func actionEdit(sender: UIBarButtonItem) {
        myTableView.setEditing(!myTableView.isEditing, animated: true)
        var item = UIBarButtonItem.SystemItem.edit
        if myTableView.isEditing {
        item = .done
        }
        editButton = UIBarButtonItem(barButtonSystemItem: item, target: self, action: #selector(actionEdit(sender:)))
        navigationItem.setRightBarButton(editButton, animated: true)
    }
}
