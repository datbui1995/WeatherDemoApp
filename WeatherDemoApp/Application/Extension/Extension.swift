//
//  Extension.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import UIKit
import Combine

extension UIViewController {
    static var className: String {
        String(describing: Self.self)
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }
}

extension Array where Element == StringValueResponse {
    var firstValue: String {
        self.first?.value ?? ""
    }
}
