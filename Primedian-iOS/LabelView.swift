//
//  LabelView.swift
//  Primedian-iOS
//
//  Created by Christopher Szatmary on 2019-08-03.
//

import UIKit
import TinyConstraints

class LabelView: UIView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        addSubview(label)
        label.centerYToSuperview()
        label.leadingToSuperview(offset: 20, usingSafeArea: true)
    }
}
