//
//  LargeTitleLabel.swift
//
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

final public class LargeTitleLabel: UILabel {

    public init() {
        super.init(frame: .zero)
        self.font = .largeTitle
        self.textColor = .onBackground
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
