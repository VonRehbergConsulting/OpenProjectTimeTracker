//
//  InfiniteTableView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import UIKit

class InfiniteTableView: UITableView {
    
    // MARK: - Subviews
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(frame: .init(x: 0, y: 0, width: 0, height: 40))
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Properties
    
    var refreshControlAction: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, style: .insetGrouped)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        tableFooterView = spinner
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Reload")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    // MARK: - Public methods
    
    func startLoading() {
        spinner.startAnimating()
    }
    
    func finishLoading(_ indexPaths: [IndexPath]) {
        spinner.stopAnimating()
        if indexPaths.isEmpty {
            let indexPath = IndexPath(row: numberOfRows(inSection: 0) - 1, section: 0)
            scrollToRow(at: indexPath, at: .bottom, animated: true)
        } else {
            beginUpdates()
            insertRows(at: indexPaths, with: .fade)
            endUpdates()
        }
    }
    
    func finishRefreshing() {
        spinner.stopAnimating()
        reloadSections([0], with: .fade)
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Actions
    
    @objc private func refresh() {
        refreshControlAction?()
    }
}
