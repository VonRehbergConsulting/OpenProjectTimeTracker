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
    var finishFlow: ((Task, TimeEntryListModel?) -> Void)?
    
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
        contentView?.segmentedControlAction = { [weak self] segment in
            self?.presenter?.modelType = .init(rawValue: segment) ?? .task
            self?.loadFirstPage()
        }
        loadFirstPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presenter else {
            Logger.log(event: .error, "Can't find presenter")
            return
        }
        presenter.outputData(at: indexPath) { [weak self] task, timeEntry in
            guard let self = self,
                  let task = task else {
                Logger.log(event: .error, "Cant load task")
                self?.showAlert(title: "Error", message: "Please, try again later")
                return
            }
            self.finishFlow?(task, timeEntry)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.itemsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reuseIdentifier, for: indexPath) as? TaskListCell,
              let item = presenter?.item(at: indexPath)
        else {
            Logger.log(event: .error, "Can't dequeue cell")
            return UITableViewCell()
        }
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
        presenter?.reloadItems { [weak self] in
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
        presenter?.loadItems { [weak self] indexPaths in
            self?.isScrolling = true
            self?.contentView?.finishLoading(indexPaths)
            self?.isLoading = false
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            Logger.log(event: .warning, "Can't get notification info")
            return
        }
        contentView?.tableViewContentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        contentView?.tableViewContentInset.bottom = 0
    }
}
