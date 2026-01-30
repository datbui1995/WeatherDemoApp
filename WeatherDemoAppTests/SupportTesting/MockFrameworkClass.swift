//
//  MockFrameworkClass.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import Foundation
import UIKit

final class SpyNavigationController: UINavigationController {

    private(set) var pushedViewControllers: [UIViewController] = []

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
        super.pushViewController(viewController, animated: false)
    }
}
