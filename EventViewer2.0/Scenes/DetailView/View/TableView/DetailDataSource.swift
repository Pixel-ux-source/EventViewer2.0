//
//  DetailDataSource.swift
//  EventViewer2.0
//
//  Created by Алексей on 25.04.2025.
//

import UIKit

final class DetailDataSource: NSObject, UITableViewDataSource {
    var model: DetailModel?
    weak var delegate: DetailViewDelegate?
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.id, for: indexPath) as? DetailCell else { fatalError("ERROR_DEQUEUE_CELL_DETAIL") }
        guard let model else { return cell }
        let id = model.id
        let date = model.date
        
        cell.onDelete = { [weak self] in
            guard let self else { return }
            self.handleDeleteButtonTapped(at: indexPath)
        }
        
        cell.setUI(id, date)
        return cell
    }
    
    private func handleDeleteButtonTapped(at indexPath: IndexPath) {
        delegate?.deleteItem(at: indexPath)
    }
    
}




