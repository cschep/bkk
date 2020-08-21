//
//  LayoutHelpers.swift
//
//  Created by Christopher Schepman on 2/1/20.
//  Copyright © 2020 Christopher Schepman. All rights reserved.
//

import UIKit

extension UIView {

    func centerX() {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])
    }

    func centerY() {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }

    func size(width: CGFloat, height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height)
        ])
    }

    func size(toHeight height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height)
        ])
    }

    func size(toWidth width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width)
        ])
    }

    func pinToBottom(of view: UIView, constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
        ])
    }

    func pinToTop(of view: UIView, constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: constant)
        ])
    }

    func pinTrailingToLeading(of view: UIView, constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -constant)
        ])
    }

    func pinToTop(constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant)
        ])
    }

    func pinToTopSafeArea(constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: constant)
        ])
    }

    func pinToBottom(constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant)
        ])
    }

    func pinToBottomSafeArea(constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -constant)
        ])
    }

    func pinToEntireSuperView(constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant)
        ])
    }

    func pinToSides(constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant)
        ])
    }

    func pinToLeading(constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant)
        ])
    }

    func pinToTrailing(constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant)
        ])
    }

    func pinToCenterX(constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: constant)
        ])
    }

    func pinToCenterY(constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: -constant)
        ])
    }

    func height(of view: UIView, multiplier: CGFloat = 1.0) {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier)
        ])
    }

    func width(of view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: constant) 
        ])
    }

}
