//
//  CommentSuggestionViewController.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 11.10.22.
//

import UIKit

final class CommentSuggestionViewController: UIViewController,
                                             UITableViewDelegate,
                                             UITableViewDataSource {
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonInset: CGFloat = 16
    }
    
    // MARK: - Subviews
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped).disableMask()
        tableView.register(CommentSuggestionViewCell.self, forCellReuseIdentifier: CommentSuggestionViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Properties
    
    var items: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var finishFlow: ((String?) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        layout()
    }
    
    private func layout() {
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)
        tableView.attachToSuperview()
    }
    
    // MARK: - UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        finishFlow?(items[indexPath.row])
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentSuggestionViewCell.reuseIdentifier) as? CommentSuggestionViewCell else { return UITableViewCell() }
        cell.configure(items[indexPath.row], at: indexPath)
        return cell
    }
}
