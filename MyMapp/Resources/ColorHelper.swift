
import UIKit
extension UIColor{
    
    class var App_BG_SeafoamBlue_Color:UIColor{
        return self.init(red: 108/255, green: 212/255, blue: 196/255, alpha: 1.0)
    }
    
    class var App_BG_SecondaryDark2_Color:UIColor{
        return self.init(red: 56/255, green: 34/255, blue: 57/255, alpha: 1.0)
    }
   
    class var App_BG_Textfield_Unselected_Border_Color:UIColor{
        return self.init(red: 215/255, green: 218/255, blue: 221/255, alpha: 1.0)
    }
    
    class var App_BG_colorsNeutralLightDark2:UIColor{
        return self.init(red: 201/255, green: 205/255, blue: 209/255, alpha: 1.0)
    }
    
    class var App_BG_App_BG_colorsNeutralLightDark2:UIColor{
        return self.init(red: 229/255, green: 231/255, blue: 232/255, alpha: 1.0)
    }
    
    class var App_BG_App_BG_colorsNeutralLightLighter2:UIColor{
        return self.init(red: 242/255, green: 243/255, blue: 244/255, alpha: 1.0)
    }
    
    class var blackTextColor:UIColor{
        return self.init(red: 56/255, green: 34/255, blue: 57/255, alpha: 1.0)
    }
    
    class var App_BG_silver_Color:UIColor{
        return self.init(red: 215/255, green: 218/255, blue: 221/255, alpha: 1.0)
    }

    
    class var RadioButtonPurpleColor:UIColor{
        return self.init(red: 98/255, green: 49/255, blue: 158/255, alpha: 1.0)
    }

    

    
    class func hexColor(_ hexColorNumber:UInt32, alpha: CGFloat) -> UIColor {
        let red = (hexColorNumber & 0xff0000) >> 16
        let green = (hexColorNumber & 0x00ff00) >> 8
        let blue =  (hexColorNumber & 0x0000ff)
        return self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
}



