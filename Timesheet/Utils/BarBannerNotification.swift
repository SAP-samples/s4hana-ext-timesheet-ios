import Foundation
import SAPFiori

class BarBannerNotification {
    
    public static func positiveResponseBanner(message: String, navigationBar: FUINavigationBar) {
        // Dismiss potential curent shown banners
        navigationBar.bannerView?.dismissBanner(animated: false)
        highlightAsPositiveResponse(navigationBar)
        navigationBar.bannerView?.show(message: message, withDuration: 3, animated: true)
    }
    
    public static func negativeResponseBanner(message: String, navigationBar: FUINavigationBar) {
        // Dismiss potential curent shown banners
        navigationBar.bannerView?.dismissBanner(animated: false)
        highlightAsNegativeResponse(navigationBar)
        navigationBar.bannerView?.show(message: message, withDuration: 3, animated: true)
    }
    
    private static func highlightAsNegativeResponse(_ navigationBar: FUINavigationBar){
        let redLightBannerColor = UIColor.init(hexString: "FF9B9B")
        let redDarkBannerColor = UIColor.init(hexString: "D9364C")
        
        navigationBar.bannerView?.titleLabel.highlightedTextColor = redDarkBannerColor
        navigationBar.bannerView?.titleLabel.textColor = redDarkBannerColor
        navigationBar.bannerView?.dividerTop.backgroundColor = redDarkBannerColor
        navigationBar.bannerView?.backgroundColor = redLightBannerColor
    }
    
    private static func highlightAsPositiveResponse(_ navigationBar: FUINavigationBar){
        let greenLightBannerColor = UIColor.init(hexString: "8EF79F")
        let greenDarkBannerColor = UIColor.init(hexString: "3A835B")
        
        navigationBar.bannerView?.titleLabel.highlightedTextColor = greenDarkBannerColor
        navigationBar.bannerView?.titleLabel.textColor = greenDarkBannerColor
        navigationBar.bannerView?.dividerTop.backgroundColor = greenDarkBannerColor
        navigationBar.bannerView?.backgroundColor = greenLightBannerColor
    }
}
