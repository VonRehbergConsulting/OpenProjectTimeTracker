//
//  TimerViewController.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

protocol TimerViewProtocol: AnyObject {
    
}

final class TimerViewController: UIViewController,
                                 TimerViewProtocol,
                                 UITableViewDelegate,
                                 UITableViewDataSource {
    
    // MARK: - Properties
    
    var contentView: TimerContentViewProtocol? { view as? TimerContentViewProtocol }
    
    var presenter: TimerPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = TimerContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView?.setDelegates(dataSource: self, delegate: self)
        presenter?.loadTasks { [weak self] indexPaths in
            self?.contentView?.insertItems(at: indexPaths)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.taskCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimerTaskCell.reuseIdentifier, for: indexPath) as? TimerTaskCell else {
            Logger.log(event: .error, "Can't dequeue cell")
            return UITableViewCell()
        }
        let item = presenter?.item(at: indexPath) ?? .init(subject: "")
        cell.configure(item, at: indexPath)
        return cell
    }
    
}
