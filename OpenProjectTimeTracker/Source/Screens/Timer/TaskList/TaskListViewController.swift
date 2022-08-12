//
//  TaskListViewController.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 09.08.22.
//

import UIKit

protocol TaskListViewProtocol: AnyObject {
    
}

final class TaskListViewController: UIViewController,
                                    TaskListViewProtocol,
                                    UITableViewDelegate,
                                    UITableViewDataSource{
    
    // MARK: - Properties
    
    var contentView: TaskListContentView? { view as? TaskListContentView }
    
    var presenter: TaskListPresenterProtocol?
    var finishFlow: ((Task) -> Void)?
    
    private var isLoading = false
    private var isScrolling = false
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = TaskListContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select task"
        contentView?.setDelegates(dataSource: self, delegate: self)
        contentView?.refreshControlAction = { [weak self] in
            self?.loadFirstPage()
        }
        loadFirstPage()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let task = presenter?.task(at: indexPath) else {
            Logger.log(event: .error, "Can't find task")
            return
        }
        finishFlow?(task)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.taskCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimerListCell.reuseIdentifier, for: indexPath) as? TimerListCell else {
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
        if y > h,
           !isScrolling {
            loadNextPage()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isScrolling = false
    }
    
    // MARK: - Private helpers
    
    private func loadFirstPage() {
        isLoading = true
        presenter?.reloadTasks { [weak self] in
            self?.contentView?.finishRefreshing()
            self?.isLoading = false
        }
    }
    
    private func loadNextPage() {
        guard !isLoading,
              !isScrolling
        else { return }
        contentView?.startLoading()
        isLoading = true
        presenter?.loadTasks { [weak self] indexPaths in
            self?.isScrolling = true
            self?.contentView?.finishLoading(indexPaths)
            self?.isLoading = false
        }
    }
}
