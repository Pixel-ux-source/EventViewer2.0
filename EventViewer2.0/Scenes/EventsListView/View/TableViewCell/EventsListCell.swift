//
//  EvenetsListCell.swift
//  EventViewer2.0
//
//  Created by Алексей on 16.04.2025.
//

import UIKit
import SnapKit

final class EventsListCell: UITableViewCell {
    // MARK: – UI Element's
    private lazy var dateLabel = DateLabel()
    private lazy var nameLabel = NameLabel()

    // MARK: – Cell ID
    static var id: String {
        String(describing: self)
    }
    
    // MARK: – Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: – Setup's
    private func setupUI() {
        setupLabel()
    }
    
    private func setupLabel() {
        contentView.addSubviews(nameLabel, dateLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.leading.greaterThanOrEqualTo(nameLabel.snp_trailingMargin).inset(8)
            make.verticalEdges.equalToSuperview().inset(8)
        }
    }
    
    func setUI(_ name: String, _ date: String) {
        DispatchQueue.main.async {
            self.nameLabel.text = name
            self.dateLabel.text = date
        }
    }
}
