//
//  RepositoryCell.swift
//  Test Assignment
//
//  Created by Johannes Grün on 24.01.21.
//

import UIKit

class RepositoryCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var shaLabel: UILabel?
    
    @IBOutlet weak var languageLabel: UILabel?
    @IBOutlet weak var watchersLabel: UILabel?
    @IBOutlet weak var forksLabel: UILabel?

    @IBOutlet weak var wrapperView: UIView?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Round some of the Cells corners
        wrapperView?.roundCorners(at: [.layerMaxXMinYCorner,
                                       .layerMinXMaxYCorner,
                                       .layerMaxXMaxYCorner], radius: 15.0)
    }
}
