import UIKit

extension UIButton {
    
    /// Retrieves a Ron Swanson image from a pseudo-randomly chosen image URL,
    /// and assigns it to the button's background image
    func getSingleSwansonImage() {
        
        let swansonImages = RonSwansonServiceClient.swansonImages
        let randomIndex = Int(arc4random_uniform(UInt32(swansonImages.count)))
        
        let image = swansonImages[randomIndex]
        
        self.setBackgroundImage(image, for: .normal)
    }
    
    /// Retrieves a Ron Swanson image from a pseudo-randomly chosen image URL,
    /// and assigns it to the button's background image with a nifty little transition
    func getSingleSwansonImageWithTransition() {
        
        let swansonImages = RonSwansonServiceClient.swansonImages
        let randomIndex = Int(arc4random_uniform(UInt32(swansonImages.count)))
        
        let image = swansonImages[randomIndex]
        
        UIView.transition(with: self,
                          duration: 1.0,
                          options: .transitionCurlUp,
                          animations: { self.setBackgroundImage(image, for: .normal)},
                          completion: nil)
    }
    
    // Similar to getSingleSwansonImageWithTransition, however image is passed-in
    // rather-than being retrieved by the extension method itself
    func setSwansonImageWithTransition(swansonImage: UIImage?) {
        
        if let swansonImage = swansonImage {
            UIView.transition(with: self,
                              duration: 1.0,
                              options: .transitionCurlUp,
                              animations: { self.setBackgroundImage(swansonImage, for: .normal)},
                              completion: nil)
        }
    }
    
    // Adds a simple shadow to the UIButton
    func addShadow() {
        
        // Adjust button shadow color, offset, radius, & opacity
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1.0
    }
}
