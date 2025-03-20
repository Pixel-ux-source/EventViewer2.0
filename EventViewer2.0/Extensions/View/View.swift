//
//  View.swift
//  EventViewer2.0
//
//  Created by Алексей on 16.04.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
