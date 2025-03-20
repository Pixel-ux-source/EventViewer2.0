//
//  EventsListViewController.swift
//  EventViewer
//
//  Created by Ilya Kharlamov on 1/26/23.
//

import UIKit

class EventsListViewController: UITableViewController {
    
    // MARK: - Outlets
    
    private lazy var logoutBarButtonItem = UIBarButtonItem(
        title: "Logout",
        style: .plain,
        target: self,
        action: #selector(EventsListViewController.logout)
    )
    
    // MARK: - Variables
    
    private let eventManager: EventManager
    
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
        print("🟢 EventsListViewController загружен!")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("🟢 EventsListViewController появился на экране!")
        eventManager.capture(.viewScreen("EVENTS_LIST"))
    }
    
    // MARK: - Configuration
    
    private func configureUI() {
        navigationItem.title = "Events List"
        navigationItem.rightBarButtonItem = self.logoutBarButtonItem
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    // MARK: - Actions
    
    @objc
    private func logout() {
        eventManager.capture(.logout)
        let vc = LoginViewController(eventManager: eventManager)
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
}
