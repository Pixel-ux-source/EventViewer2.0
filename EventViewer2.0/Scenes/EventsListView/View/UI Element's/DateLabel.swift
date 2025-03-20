//
//  Label.swift
//  EventViewer2.0
//
//  Created by Алексей on 08.04.2025.
//

import UIKit

final class DateLabel: UILabel {
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
        textColor = .darkGray
        font = .systemFont(ofSize: 14, weight: .regular)
        numberOfLines = 1
    }
    
}
