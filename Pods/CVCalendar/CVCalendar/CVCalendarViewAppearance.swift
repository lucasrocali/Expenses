//
//  CVCalendarViewAppearance.swift
//  CVCalendar
//
//  Created by E. Mozharovsky on 12/26/14.
//  Copyright (c) 2014 GameApp. All rights reserved.
//

import UIKit

public final class CVCalendarViewAppearance: NSObject {
    
    public override init() {
        super.init()
    }
    
    /// Default rendering options.
    public var spaceBetweenWeekViews: CGFloat? = 0
    public var spaceBetweenDayViews: CGFloat? = 0
    
    /// Default text options.
    public var dayLabelPresentWeekdayInitallyBold: Bool? = true
    public var dayLabelWeekdayFont: UIFont? = UIFont(name: "Copperplate", size:16)

    public var dayLabelPresentWeekdayFont: UIFont? = UIFont(name: "Copperplate", size:16)

    public var dayLabelPresentWeekdayBoldFont: UIFont? = UIFont(name: "Copperplate", size:16)
    public var dayLabelPresentWeekdayHighlightedFont: UIFont? = UIFont(name: "Copperplate", size:16)
    public var dayLabelPresentWeekdaySelectedFont: UIFont? = UIFont(name: "Copperplate", size:16)
    public var dayLabelWeekdayHighlightedFont: UIFont? = UIFont(name: "Copperplate", size:16)
    public var dayLabelWeekdaySelectedFont: UIFont? = UIFont(name: "Copperplate", size:16)
    /// Default text color.
    public var dayLabelWeekdayInTextColor: UIColor? = .blackColor()
    public var dayLabelWeekdayOutTextColor: UIColor? = .grayColor()
    public var dayLabelWeekdayHighlightedTextColor: UIColor? = .whiteColor()
    public var dayLabelWeekdaySelectedTextColor: UIColor? = .whiteColor()
    public var dayLabelPresentWeekdayTextColor: UIColor? = UIColor(red: 80/255, green: 124/255, blue: 109/255, alpha: 1)
    public var dayLabelPresentWeekdayHighlightedTextColor: UIColor? = .whiteColor()
    public var dayLabelPresentWeekdaySelectedTextColor: UIColor? = .whiteColor()
    
    /// Default text size.
    public var dayLabelWeekdayTextSize: CGFloat? = 16
    public var dayLabelWeekdayHighlightedTextSize: CGFloat? = 16
    public var dayLabelWeekdaySelectedTextSize: CGFloat? = 16
    public var dayLabelPresentWeekdayTextSize: CGFloat? = 16
    public var dayLabelPresentWeekdayHighlightedTextSize: CGFloat? = 16
    public var dayLabelPresentWeekdaySelectedTextSize: CGFloat? = 16
    
    /// Default highlighted state background & alpha.
    public var dayLabelWeekdayHighlightedBackgroundColor: UIColor? = UIColor(red: 80/255, green: 124/255, blue: 109/255, alpha: 1)

    public var dayLabelWeekdayHighlightedBackgroundAlpha: CGFloat? = 0.8
    public var dayLabelPresentWeekdayHighlightedBackgroundColor: UIColor? = UIColor(red: 80/255, green: 124/255, blue: 109/255, alpha: 1)

    public var dayLabelPresentWeekdayHighlightedBackgroundAlpha: CGFloat? = 0.8
    
    /// Default selected state background & alpha.
    public var dayLabelWeekdaySelectedBackgroundColor: UIColor? = UIColor(red: 80/255, green: 124/255, blue: 109/255, alpha: 1)

    public var dayLabelWeekdaySelectedBackgroundAlpha: CGFloat? = 0.8
    public var dayLabelPresentWeekdaySelectedBackgroundColor: UIColor? = UIColor(red: 80/255, green: 124/255, blue: 109/255, alpha: 1)

    public var dayLabelPresentWeekdaySelectedBackgroundAlpha: CGFloat? = 0.8
    
    
    // Default dot marker color.
    public var dotMarkerColor: UIColor? = .whiteColor()
    
    public var delegate: CVCalendarViewAppearanceDelegate? {
        didSet {
            self.setupAppearance()
        }
    }
    
    public func setupAppearance() {
        if let delegate = delegate {
            spaceBetweenWeekViews~>delegate.spaceBetweenWeekViews?()
            spaceBetweenDayViews~>delegate.spaceBetweenDayViews?()
            
            dayLabelPresentWeekdayInitallyBold~>delegate.dayLabelPresentWeekdayInitallyBold?()
            dayLabelWeekdayFont~>delegate.dayLabelWeekdayFont?()
            dayLabelPresentWeekdayFont~>delegate.dayLabelPresentWeekdayFont?()
            dayLabelPresentWeekdayBoldFont~>delegate.dayLabelPresentWeekdayBoldFont?()
            dayLabelPresentWeekdayHighlightedFont~>delegate.dayLabelPresentWeekdayHighlightedFont?()
            dayLabelPresentWeekdaySelectedFont~>delegate.dayLabelPresentWeekdaySelectedFont?()
            dayLabelWeekdayHighlightedFont~>delegate.dayLabelWeekdayHighlightedFont?()
            dayLabelWeekdaySelectedFont~>delegate.dayLabelWeekdaySelectedFont?()
            
            dayLabelWeekdayInTextColor~>delegate.dayLabelWeekdayInTextColor?()
            dayLabelWeekdayOutTextColor~>delegate.dayLabelWeekdayOutTextColor?()
            dayLabelWeekdayHighlightedTextColor~>delegate.dayLabelWeekdayHighlightedTextColor?()
            dayLabelWeekdaySelectedTextColor~>delegate.dayLabelWeekdaySelectedTextColor?()
            dayLabelPresentWeekdayTextColor~>delegate.dayLabelPresentWeekdayTextColor?()
            dayLabelPresentWeekdayHighlightedTextColor~>delegate.dayLabelPresentWeekdayHighlightedTextColor?()
            dayLabelPresentWeekdaySelectedTextColor~>delegate.dayLabelPresentWeekdaySelectedTextColor?()
            
            dayLabelWeekdayTextSize~>delegate.dayLabelWeekdayTextSize?()
            dayLabelWeekdayHighlightedTextSize~>delegate.dayLabelWeekdayHighlightedTextSize?()
            dayLabelWeekdaySelectedTextSize~>delegate.dayLabelWeekdaySelectedTextSize?()
            dayLabelPresentWeekdayTextSize~>delegate.dayLabelPresentWeekdayTextSize?()
            dayLabelPresentWeekdayHighlightedTextSize~>delegate.dayLabelPresentWeekdayHighlightedTextSize?()
            dayLabelPresentWeekdaySelectedTextSize~>delegate.dayLabelPresentWeekdaySelectedTextSize?()
            
            dayLabelWeekdayHighlightedBackgroundColor~>delegate.dayLabelWeekdayHighlightedBackgroundColor?()
            dayLabelWeekdayHighlightedBackgroundAlpha~>delegate.dayLabelWeekdayHighlightedBackgroundAlpha?()
            dayLabelPresentWeekdayHighlightedBackgroundColor~>delegate.dayLabelPresentWeekdayHighlightedBackgroundColor?()
            dayLabelPresentWeekdayHighlightedBackgroundAlpha~>delegate.dayLabelPresentWeekdayHighlightedBackgroundAlpha?()
            
            dayLabelWeekdaySelectedBackgroundColor~>delegate.dayLabelWeekdaySelectedBackgroundColor?()
            dayLabelWeekdaySelectedBackgroundAlpha~>delegate.dayLabelWeekdaySelectedBackgroundAlpha?()
            dayLabelPresentWeekdaySelectedBackgroundColor~>delegate.dayLabelPresentWeekdaySelectedBackgroundColor?()
            dayLabelPresentWeekdaySelectedBackgroundAlpha~>delegate.dayLabelPresentWeekdaySelectedBackgroundAlpha?()
            
            dotMarkerColor~>delegate.dotMarkerColor?()
        }
    }
}

infix operator ~> { }
public func ~><T: Any>(inout lhs: T?, rhs: T?) -> T? {
    if lhs != nil && rhs != nil {
        lhs = rhs
    }

    return lhs
}

extension UIColor {
    public static func colorFromCode(code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
