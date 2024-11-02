//
//  BodyLabel.swift
//
//
//  Created by Kevin Morais on 02/11/2024.
//

import UIKit

final public class BodyLabel: UILabel {
    public init() {
        super.init(frame: .zero)
        self.font = .body
        self.textColor = .tertiaryLabel
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
