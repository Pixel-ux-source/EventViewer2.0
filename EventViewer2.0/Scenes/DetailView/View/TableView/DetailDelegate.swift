//
//  DetailDelegate.swift
//  EventViewer2.0
//
//  Created by Алексей on 25.04.2025.
//

import UIKit

final class DetailDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
