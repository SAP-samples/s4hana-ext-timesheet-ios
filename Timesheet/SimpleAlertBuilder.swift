import Foundation
import UIKit

class SimpleAlertBuilder {
    
    private var title = ""
    private var message = ""
    private var actionText: String?
    
    private var okAction: (UIAlertAction) -> Void = { _ in
    }
    
    public func title(_ title: String) -> SimpleAlertBuilder {
        self.title = title
        return self
    }
    
    public func message(_ message: String) -> SimpleAlertBuilder {
        self.message = message
        return self
    }
    
    public func okAction(_ action: @escaping (UIAlertAction) -> Void) -> SimpleAlertBuilder {
        self.okAction = action
        return self
    }
    
    public func okActionText(_ text: String) -> SimpleAlertBuilder {
        self.actionText = text
        return self
    }
    
    public func build() -> UIAlertController {
        var okAction: UIAlertAction?
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if actionText != nil {
            okAction = UIAlertAction(title: actionText, style: .default, handler: self.okAction)
        }
        else {
            okAction = UIAlertAction(title: NSLocalizedString("okKey", value: "OK", comment: "OK"), style: .default, handler: self.okAction)
        }
        
        alert.addAction(okAction!)
        
        return alert
    }
}
