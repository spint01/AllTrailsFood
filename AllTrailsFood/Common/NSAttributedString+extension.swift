//
//  NSAttributedString+extension.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/21/21.
//

import UIKit

extension NSAttributedString {
    convenience init(image: UIImage, offset: CGPoint = .zero) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: offset.x, y: offset.y, width: image.size.width, height: image.size.height)
        self.init(attachment: attachment)
    }
}
