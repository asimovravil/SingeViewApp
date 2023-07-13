//
//  TaskViewController.swift
//  maki-maki-ios
//
//  Created by Ravil on 06.06.2023.
//

import UIKit
import SnapKit

final class TaskViewController: UIViewController {

    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 148
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    // MARK: - setupViews
    
    private func setupViews() {
        view.addSubview(tableView)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationItem.rightBarButtonItem = addButton
    }

    // MARK: - setupConstraints
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc private func addTask() {
        let alertController = UIAlertController(title: "Новая задача", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите имя задачи"
        }
        let addAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            if let taskName = alertController.textFields?.first?.text {
                self.tasks.append(taskName)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

}

extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as? TaskTableCell else {
            fatalError("Could not dequeue TaskTableCell")
        }
        
        let task = tasks[indexPath.row]
        cell.taskNameLabel.text = task
        cell.completeButton.tag = indexPath.row
        cell.completeButton.addTarget(self, action: #selector(completeTask(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func completeTask(_ sender: UIButton) {
        let index = sender.tag
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
