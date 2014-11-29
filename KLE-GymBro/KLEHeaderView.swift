//
//  KLEHeaderView.swift
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/26/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

import Foundation
import UIKit

@objc class KLEHeaderView: UIView {
    
    @IBOutlet weak var contentView: KLEHeaderView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var exerciseCountLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    
    override init() {
        super.init()
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("KLEHeaderView", owner: self, options: nil)
        self.addSubview(contentView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NSLog("Awake from Nib");
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLog("Layout subviews")
    }
}