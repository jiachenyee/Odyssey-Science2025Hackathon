//
//  Data.swift
//  SCS hackathon
//
//  Created by JiaChen(: on 1/12/18.
//  Copyright © 2018 SST Inc. All rights reserved.
//

import Foundation
import UIKit

struct createExhibit {
    var exhibitTitle: String
    var exhibitDescription: String
    var exhibitImage: UIImage
}

var exhibits: [createExhibit] = [
    createExhibit(exhibitTitle: "Sound Dish", exhibitDescription: "", exhibitImage: UIImage(named: "IMG_1502.HEIC")!),
    createExhibit(exhibitTitle: "Talking Bob", exhibitDescription: "Turn Bob's nose six times quickly. Once you hear a beep, speak into Bob's mouth and listen attentively. What do you hear? Bob has changed your voice into that of a robot! \n\nWhen winding Bob's nose, mechanical energy is converted into electrical energy. THis powers the micro-chip brain that records the input voice, distorts it and plays it back.", exhibitImage: UIImage(named: "IMG_2487.HEIC")!),
    createExhibit(exhibitTitle: "Lithophone", exhibitDescription: "Did you know ", exhibitImage: UIImage(named: "IMG_7706.HEIC")!),
    createExhibit(exhibitTitle: "Time Capsule", exhibitDescription: "", exhibitImage: UIImage(named: "IMG_2861.HEIC")!),
    createExhibit(exhibitTitle: "Fountain", exhibitDescription: "", exhibitImage: UIImage(named: "IMG_4621.HEIC")!),
    createExhibit(exhibitTitle: "Dragon", exhibitDescription: "", exhibitImage: UIImage(named: "IMG_5817.HEIC")!)
    ]
