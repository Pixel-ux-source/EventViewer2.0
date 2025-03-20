//
//  NameLabel.swift
//  EventViewer2.0
//
//  Created by Алексей on 16.04.2025.
//

import UIKit

final class NameLabel: UILabel {
    // MARK: – Life Cycle
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: – Setup
    private func setup() {
        textColor = .label
        font = .systemFont(ofSize: 14, weight: .medium)
        numberOfLines = 1
    }
}
