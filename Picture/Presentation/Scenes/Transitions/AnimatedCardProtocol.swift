//
//  AnimatedCardProtocol.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

protocol SourceAnimatedCardProtocol where Self: UIViewController {
    var sourceAnimationView: UIView? { get }
}

protocol DestinationAnimatedCardProtocol where Self: UIViewController {
    var destinationAnimationView: UIView { get }
}
