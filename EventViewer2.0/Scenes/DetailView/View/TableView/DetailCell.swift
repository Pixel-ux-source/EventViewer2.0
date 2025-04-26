//
//  DetailCell.swift
//  EventViewer2.0
//
//  Created by Алексей on 25.04.2025.
//

import UIKit
import SnapKit

final class DetailCell: UITableViewCell {
    // MARK: – Cell ID
    static var id: String {
        String(describing: self)
    }
    
    // MARK: – Variable's
    var onDelete: (() -> ())?
    
    // MARK: – UI Element's
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        btn.tintColor = .red
        btn.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    // MARK: – Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: –  Configuration's
    private func configureView() {
        contentView.backgroundColor = .systemBackground
    }
    
    // MARK: – Setup's
    private func setupUI() {
        contentView.addSubviews(stackView, deleteBtn)
        setupStack()
        setupBtn()
    }
    
    private func setupStack() {
        stackView.addArrangedSubview(idLabel)
        stackView.addArrangedSubview(dateLabel)
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    private func setupBtn() {
        deleteBtn.snp.makeConstraints { make in
            make.centerY.equalTo(stackView.snp_centerYWithinMargins)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setUI(_ id: String, _ date: String) {
        idLabel.text = id
        dateLabel.text = date
    }
    
    // MARK: – @OBJC func
    @objc
    private func deleteButtonTapped() {
        onDelete?()
    }
    
}
