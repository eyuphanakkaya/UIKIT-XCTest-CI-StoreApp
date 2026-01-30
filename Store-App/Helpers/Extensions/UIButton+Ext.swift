//
//  UIButton+Ext.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 30.01.2026.
//

import Foundation
import UIKit

extension UIButton {
    
    private struct AssociatedKeys {
        static var actionKey = "actionKey"
    }
    
    private class ActionWrapper {
        let action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        @objc func invoke() {
            action()
        }
    }
    
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, action: @escaping () -> Void) {
        let wrapper = ActionWrapper(action: action)
        addTarget(wrapper, action: #selector(ActionWrapper.invoke), for: controlEvents)
        objc_setAssociatedObject(self, &AssociatedKeys.actionKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
