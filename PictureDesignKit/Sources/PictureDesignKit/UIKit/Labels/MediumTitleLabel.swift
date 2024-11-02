//
//  MediumTitleLabel.swift
//
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

final public class MediumTitleLabel: UILabel {

    public init() {
        super.init(frame: .zero)
        self.font = .mediumTitle
        self.textColor = .tertiary
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var text: String? {
        didSet {
            super.text = text?.uppercased()
        }
    }

}
