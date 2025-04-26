//
//  DetailController.swift
//  EventViewer2.0
//
//  Created by Алексей on 25.04.2025.
//

import UIKit
import SnapKit

protocol DetailViewDelegate: AnyObject {
    func transitionId(to id: String, _ vc: DetailController)
    func transitionDate(to date: Date, _ vc: DetailController)
    func deleteItem(at indexPath: IndexPath)
}

final class DetailController: UIViewController {
    // MARK: – Instance's
    private let tableView = DetailTableView()
    private let dataSource = DetailDataSource()
    private let tableDelegate = DetailDelegate()
    
    // MARK: – Variable's
    var eventManager: EventManager?
    var id: String?
    var date: String?
    
    // MARK: – Delegate
    weak var delegate: DetailViewDelegate?
    
    // MARK: – LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventManager?.capture(.viewScreen("DETAIL_VIEW"))
    }
    
    // MARK: – Configuration
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBar() {
        title = "Detail event"
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        tableView.dataSource = dataSource
        tableView.delegate = tableDelegate
        
        guard let id = id else { return }
        guard let date = date else { return }
        
        dataSource.model = DetailModel(id: id, date: date)
        dataSource.delegate = delegate
    }
}
