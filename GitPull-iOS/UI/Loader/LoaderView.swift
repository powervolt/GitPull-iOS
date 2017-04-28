//
//  LoaderView.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    static func viewFromXIB() -> LoaderView {
        var views = Bundle.main.loadNibNamed("LoaderView", owner: nil, options: nil)
        if let view = views?[0] as? LoaderView {
            return view
        }
        
        return LoaderView()
    }
    
    func showSpinner(on controller: UIViewController) {
        self.hideSpinner(from: controller)
        self.frame = controller.view.frame
        
        UIView.transition(with: controller.view, duration: 0.3, options: .transitionCrossDissolve, animations: {() -> Void in
            controller.view.addSubview(self)
            controller.view.bringSubview(toFront: self)
        }, completion: { _ in })
     
    }
    
    func hideSpinner(from controller: UIViewController) {
        for subView in controller.view.subviews {
            if subView is LoaderView {
                UIView.transition(with: controller.view, duration: 0.3, options: .transitionCrossDissolve, animations: {() -> Void in
                    subView.removeFromSuperview()
                }, completion: { _ in })
                return
            }
        }
    }

}
