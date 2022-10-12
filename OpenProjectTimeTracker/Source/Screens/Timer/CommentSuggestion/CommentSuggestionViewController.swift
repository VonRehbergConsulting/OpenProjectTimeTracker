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
    
    private lazy var closeButton: DSButton = {
        let button = DSButton().disableMask()
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var items: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var finishFlow: ((String) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    private func layout() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(tableView)
        view.addSubview(closeButton)
        
        tableView.attachToSuperview()
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonInset),
            closeButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            closeButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonAction() {
        dismiss(animated: true)
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
        dismiss(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentSuggestionViewCell.reuseIdentifier) as? CommentSuggestionViewCell else { return UITableViewCell() }
        cell.configure(items[indexPath.row], at: indexPath)
        return cell
    }
}
