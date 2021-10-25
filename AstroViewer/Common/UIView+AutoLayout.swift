//
//  UIView+AutoLayout.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import UIKit

extension UIView {

    func apply(constraints: [NSLayoutConstraint]) {
        guard superview != nil else {
            assert(false, "\(self) must have a superview for constraints to be added")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

}
