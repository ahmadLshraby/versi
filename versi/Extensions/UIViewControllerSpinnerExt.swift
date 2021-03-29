

import UIKit

extension UIViewController {
    
    func shouldPresentLoadingView(_ status: Bool) {
        var fadeView: UIView?
        
        if status == true {
            fadeView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
//            fadeView?.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.3867134452, blue: 0.5730444193, alpha: 1)
//            fadeView?.alpha = 1.0
            fadeView?.tag = 99
            
            let spinner = UIActivityIndicatorView()
            spinner.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            if #available(iOS 13.0, *) {
                spinner.style = .large
            } else {
                spinner.style = .whiteLarge
            }
            spinner.center = view.center
            
            view.addSubview(fadeView!)
            fadeView?.addSubview(spinner)
            
            spinner.startAnimating()
            
            fadeView?.fadeTo(alphaValue: 1.0, withDuration: 0.2)
        }else {
            for subview in view.subviews {
                if subview.tag == 99 {
                    UIView.animate(withDuration: 0.2, animations: {
                        subview.alpha = 0.0
                    }) { (finished) in
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    
    
    
    func shouldPresentAlertView(_ status: Bool, title: String?, alertText: String?, actionTitle: String?, errorView: UIView?) {
        var fadeView: UIView?
        
        if status == true {
            fadeView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            fadeView?.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.3867134452, blue: 0.5730444193, alpha: 1)
            fadeView?.alpha = 1.0
            fadeView?.tag = 100
            
            let alert = UIAlertController(title: title, message: alertText, preferredStyle: .alert)
            alert.view.tintColor = #colorLiteral(red: 0.121986337, green: 0.3321746588, blue: 0.5903266072, alpha: 1)
            let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] action in
                self?.shouldPresentAlertView(false, title: nil, alertText: nil, actionTitle: nil, errorView: nil)
                errorView?.shake()
//                errorView?.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//                errorView?.layer.borderWidth = 2.0
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            view.addSubview(fadeView!)
            
            fadeView?.fadeTo(alphaValue: 0.7, withDuration: 0.2)
        }else {
            for subview in view.subviews {
                if subview.tag == 100 {
                    UIView.animate(withDuration: 0.2, animations: {
                        subview.alpha = 0.0
                    }) { (finished) in
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func shouldPresentAlertViewWithAction(withTitle title: String, message msg: String,
                                          yesActionTitle: String, noActionTitle: String?,
                                          yesActionColor: UIColor, noActionColor: UIColor,
                                          delegate del: Any?, parentViewController parentVC: UIViewController, completionHandler: @escaping (Bool) -> Void ) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: yesActionTitle, style: .default) { (response) in
            completionHandler(true)
        }
        yesAction.setValue(yesActionColor, forKey: "titleTextColor")
        alert.addAction(yesAction)
        
        if let no = noActionTitle {
            let noAction = UIAlertAction(title: no, style: .cancel) { (response) in
                completionHandler(false)
            }
            noAction.setValue(noActionColor, forKey: "titleTextColor")
            alert.addAction(noAction)
        }
        
        parentVC.present(alert as UIViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    func shouldPresentSearchingView(_ status: Bool) {
        var fadeView: UIView?
        
        if status == true {
            fadeView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            fadeView?.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.5176470588, blue: 0.09019607843, alpha: 1)
            fadeView?.alpha = 0.0
            fadeView?.tag = 102
            
            let label = UILabel(frame: CGRect(x: 20, y: 50, width: view.frame.width - 20, height: 60))
            label.textAlignment = .center
            label.text = "Allocating driver to pick up your order"
            label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            label.font = UIFont.systemFont(ofSize: 20)
            
            let image = UIImage(named: "delivery-man")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
            imageView.center = view.center
            imageView.contentMode = .scaleAspectFit
            
            
            
            view.addSubview(fadeView!)
            fadeView?.addSubview(label)
            fadeView?.addSubview(imageView)
            
            
            fadeView?.fadeTo(alphaValue: 0.7, withDuration: 0.2)
        }else {
            for subview in view.subviews {
                if subview.tag == 102 {
                    UIView.animate(withDuration: 0.2, animations: {
                        subview.alpha = 0.0
                    }) { (finished) in
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    
    
}
