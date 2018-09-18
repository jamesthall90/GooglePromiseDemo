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
}
