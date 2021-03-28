

import UIKit

extension UIView{
    
    func fadeTo(alphaValue: CGFloat, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = alphaValue
        }
    }
    
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @objc func keyboardWillChange(_ notification: NSNotification){
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: { (done) in
            NotificationCenter.default.removeObserver(self)
        })
    }
    
    func rotate180(duration: TimeInterval, angle: CGFloat, options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.transform = self.transform.rotated(by: angle)
        }, completion: nil)
    }
    
    func rotateWithSpring() {
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.transform = .identity
            },
                       completion: nil)
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.5
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    func animationRoted(angle : CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }
    
    var snapshot: UIImage? {
            let renderer = UIGraphicsImageRenderer(size: bounds.size)

            let image = renderer.image { context in
                layer.render(in: context.cgContext)
            }
            return image
        }
    
    func flash() {
            // Take as snapshot of the button and render as a template
            let snapshot = self.snapshot?.withRenderingMode(.alwaysTemplate)
            let imageView = UIImageView(image: snapshot)
            // Add it image view and render close to white
            imageView.tintColor = UIColor(white: 0.9, alpha: 1.0)
            guard let image = imageView.snapshot  else { return }
            let width = image.size.width
            let height = image.size.height
            // Create CALayer and add light content to it
            let shineLayer = CALayer()
            shineLayer.contents = image.cgImage
            shineLayer.frame = bounds

            // create CAGradientLayer that will act as mask clear = not shown, opaque = rendered
            // Adjust gradient to increase width and angle of highlight
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor,
                                    UIColor.clear.cgColor,
                                    UIColor.black.cgColor,
                                    UIColor.clear.cgColor,
                                    UIColor.clear.cgColor]
            gradientLayer.locations = [0.0, 0.35, 0.50, 0.65, 0.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

            gradientLayer.frame = CGRect(x: -width, y: 0, width: width, height: height)
            // Create CA animation that will move mask from outside bounds left to outside bounds right
            let animation = CABasicAnimation(keyPath: "position.x")
            animation.byValue = width * 2
            // How long it takes for glare to move across button
            animation.duration = 3
            // Repeat forever
            animation.repeatCount = Float.greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

            layer.addSublayer(shineLayer)
            shineLayer.mask = gradientLayer

            // Add animation
            gradientLayer.add(animation, forKey: "shine")
        }

        func stopFlash() {
            // Search all sublayer masks for "shine" animation and remove
            layer.sublayers?.forEach {
                $0.mask?.removeAnimation(forKey: "shine")
            }
        }
    
    func applyGradient(colours: [UIColor]) {
        self.applyGradient(colours: colours, locations: nil)
    }

    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        self.layer.addSublayer(gradient)
    }

    func applyWithAlphaGradient(colours: [UIColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.withAlphaComponent(0.8).cgColor }
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
       self.layer.insertSublayer(gradient, at: 0)
    }
    
    func prepareAnimationView(x: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(translationX: x, y: y)
    }
    
    func startAnimationView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
}
