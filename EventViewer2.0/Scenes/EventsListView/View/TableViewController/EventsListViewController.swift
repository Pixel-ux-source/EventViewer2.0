//
//  EventsListViewController.swift
//  EventViewer
//
//  Created by Ilya Kharlamov on 1/26/23.
//

import UIKit
import SnapKit

protocol DelegateEventsListView: AnyObject {
    func didTapUpdate()
}

class EventsListViewController: UITableViewController {
    // MARK: – Event's Model
    private var events: [DBEvent] = []
    
    // MARK: - Outlet's
    private lazy var logoutBarButtonItem = UIBarButtonItem(
        title: "Logout",
        style: .plain,
        target: self,
        action: #selector(EventsListViewController.logout)
    )
        
    // MARK: - Variable's
    private let eventManager: EventManager
    private var isLoadingNextPage = false
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredEvents: [DBEvent] = []
    private var searchText: String = ""
    
    // MARK: - Lifecycle
    init(eventManager: EventManager) {
        print("🟢 EventManager инициализирован: \(eventManager)")
        self.eventManager = eventManager
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureUI()
        registerCell()
        configureSearchController()
        print("🟢 EventsListViewController загружен!")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("🟢 EventsListViewController появился на экране!")
        eventManager.capture(.viewScreen("EVENTS_LIST"))
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height {
            self.fetchNextPage()
        }
    }
    
    // MARK: – Fetch Next Page
    private func fetchNextPage() {
        let offsetY = events.count

        guard !isLoadingNextPage else { return }
        isLoadingNextPage = true
        eventManager.fetchNextPage(offsetY, Int(view.frame.height)/60) { [weak self] newEvents in
            DispatchQueue.main.async {
                guard let self else { return }
                let previosCount = self.events.count
                self.events.append(contentsOf: newEvents)
                let newIndexPath = (previosCount..<self.events.count).map { IndexPath(row: $0, section: 0) }
                
                guard !newIndexPath.isEmpty else {
                    self.isLoadingNextPage = false
                    return
                }
                
                self.tableView.insertRows(at: newIndexPath, with: .fade)
                self.isLoadingNextPage = false
            }
        }
    }
    
    // MARK: – Table DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Сделать динамическое изменение количества элементов в массиве
        events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventsListCell.id, for: indexPath) as? EventsListCell else { fatalError("ERROR_CELL_NOT_FOUND") }
        let currentEvent = events[indexPath.row]
        let nameEvent = currentEvent.id
        let dateEvent = currentEvent.createdAt
        guard let dateEvent else { fatalError("ERROR_DATE_NOT_FOUND") }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let formatterDateEvent = formatter.string(from: dateEvent)
        
        cell.setUI(nameEvent, formatterDateEvent)
        return cell
    }
    
    // MARK: – Table Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    // Action Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailController()
        vc.eventManager = eventManager
        vc.delegate = self
        vc.delegate?.transitionId(to: events[indexPath.row].id, vc)
        
        guard let date = events[indexPath.row].createdAt else { return }
        vc.delegate?.transitionDate(to: date, vc)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete record") { [weak self] (action, view, completionHandler) in
            guard let self else {
                completionHandler(false)
                return
            }
            deleteItem(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    // MARK: - Configuration
    private func configureUI() {
        navigationItem.title = "Events List"
        navigationItem.rightBarButtonItem = self.logoutBarButtonItem
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search event"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: – Register Cell
    func registerCell() {
        tableView.register(EventsListCell.self, forCellReuseIdentifier: EventsListCell.id)
    }
    
    // MARK: - Actions
    @objc
    private func logout() {
        eventManager.capture(.logout)
        let vc = LoginViewController(eventManager: eventManager)
        vc.delegate = self
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
}

    // MARK: – Extension's
extension EventsListViewController: DelegateEventsListView {
    func didTapUpdate() {
        tableView.reloadData()
    }
}

extension EventsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces) else {
            events = []
            return
        }
                
        eventManager.searchEvents(with: query) { [weak self] events in
            guard let self else { return }
            DispatchQueue.main.async {
                self.events = events
                self.tableView.reloadData()
            }
        }
    }
}

extension EventsListViewController: DetailViewDelegate {
    func transitionDate(to date: Date, _ vc: DetailController) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let formmatterDate = dateFormatter.string(from: date)
        vc.date = formmatterDate
    }
    
    func transitionId(to id: String, _ vc: DetailController) {
        vc.id = id
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let eventToDelete = self.events[indexPath.row]
        eventManager.performBackgroundTask { [weak self] context in
            guard let self else { return }
            let object = context.object(with: eventToDelete.objectID)
            context.delete(object)
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    self.events.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    print("Deleted element: \(self.events[indexPath.row].id)")
                }
            } catch let error as NSError {
                print("❌ Ошибка при удалении:", error.localizedDescription)
            }
        }
        // Если  сейчас не self, то делаем guard else { return }
        if presentedViewController != self {
            navigationController?.popViewController(animated: true)
            print("popView")
        }
    }
}

// Добавить перезагрузку данных при делите
