//
//  DetailTableView.swift
//  EventViewer2.0
//
//  Created by Алексей on 25.04.2025.
//

import UIKit

final class DetailTableView: UITableView {
    
    // MARK: – Life Cycle
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureView()
        registerCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: –  Configuration
    private func configureView() {
        backgroundColor = .clear
    }
    
    // MARK: – Register Cell
    private func registerCell() {
        register(DetailCell.self, forCellReuseIdentifier: DetailCell.id)
    }
    
}
