//
//  meme1.swift
//  meme1.0
//
//  Created by Rishav on 21/03/17.
//  Copyright © 2017 Rishav. All rights reserved.
//

import UIKit
import Foundation

struct Meme1 {
    let top: String
    let bottom: String
    let image: UIImage
    let memedImage: UIImage
    init(topText: String!, bottomText: String!, image: UIImage!, memedImage: UIImage!) {
        self.top = topText
        self.bottom = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}
