//
//  SmallTitleLabel.swift
//
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

final public class SmallTitleLabel: UILabel {

    public init() {
        super.init(frame: .zero)
        font = .smallTitle
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
