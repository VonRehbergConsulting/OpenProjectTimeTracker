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
    
    private var isLoading = false {
        didSet {
            contentView?.showSpinner = isLoading
        }
    }
    private var isLoadingBlocked = false
    
    var contentView: TimerContentViewProtocol? { view as? TimerContentViewProtocol }
    
    var presenter: TimerPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = TimerContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView?.setDelegates(dataSource: self, delegate: self)
        loadNextPage()
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
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height + 1
        if y > h {
            loadNextPage()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isLoadingBlocked = false
    }
    
    // MARK: - Private helpers
    
    private func loadNextPage() {
        guard isLoading == false,
              isLoadingBlocked == false
        else { return }
        isLoading = true
        isLoadingBlocked = true
        presenter?.loadTasks { [weak self] indexPaths in
            self?.contentView?.insertItems(at: indexPaths)
            self?.isLoading = false
        }
    }
}
