//
//  StylishInput.swift
//  StoryFlow
//
//  Created by George Smith on 10/09/2019.
//  Copyright © 2019 Trafi. All rights reserved.
//

import Foundation
import UIKit
//MARK: This protocol is used to decorate your inputs to allow for certain styling of the upcoming VC.
public protocol StylishInput {
    var modalPresentationStyle: UIModalPresentationStyle { get set }
}
