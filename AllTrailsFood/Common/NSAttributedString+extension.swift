//
//  NSAttributedString+extension.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/21/21.
//

import UIKit

extension NSAttributedString {
    convenience init(image: UIImage) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        self.init(attachment: attachment)
    }
}
