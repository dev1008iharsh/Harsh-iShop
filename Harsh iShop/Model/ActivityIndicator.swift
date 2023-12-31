//
//  ActivityIndicator.swift
//  Dr.Murad_iOSApp
//
//  Created by Harsh iOS Developer on 24/06/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable{
    func startAnimation() {
        let width = 60
        let height = 60
        let size = CGSize(width: width, height: height)
        startAnimating(size, message: "", type: NVActivityIndicatorType.ballClipRotate)
    }

    func stopAnimation() {
        self.stopAnimating()
    }
}
