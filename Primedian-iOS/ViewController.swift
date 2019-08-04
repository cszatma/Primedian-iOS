//
//  ViewController.swift
//  Primedian-iOS
//
//  Created by Christopher Szatmary on 2019-08-03.
//  Copyright © 2019 Christopher Szatmary. All rights reserved.
//

import UIKit
import TinyConstraints

class ViewController: UIViewController {
    
    // MARK: - Views
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.text = "PriMedian"
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "Find the Median Prime"
        return label
    }()
    
    let upperLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "Upper Limit"
        return label
    }()
    
    let upperLimitTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Enter a number between 2 and 100 million"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Calculate", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleCalculateButtonTouch(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor(hex: 0x5a6268)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 3
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        return button
    }()
    
    let resultLabelView: LabelView = {
        let view = LabelView()
        view.backgroundColor = UIColor(hex: 0xe9ecef)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        view.isHidden = true
        return view
    }()
    
    let errorLabelView: LabelView = {
        let view = LabelView()
        view.backgroundColor = UIColor(hex: 0xf8d7da)
        view.label.textColor = UIColor(hex: 0x721c24)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        view.isHidden = true
        return view
    }()
    
    let spinnerView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.color = UIColor(hex: 0x5a6268)
        return view
    }()

    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func handleCalculateButtonTouch(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let upperLimit = UInt64(upperLimitTextField.text ?? "") else {
            updateView(withStatus: .error(.invalidParameterType))
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            fetchResult(upperLimit: upperLimit) { [unowned self] status in
                DispatchQueue.main.async {
                    self.updateView(withStatus: status)
                }
            }
        }
        
        updateView(withStatus: .loading)
    }
    
    func updateView(withStatus status: Status) {
        switch status {
        case .loading:
            resultLabelView.isHidden = true
            errorLabelView.isHidden = true
            spinnerView.startAnimating()
        case .complete(let result):
            spinnerView.stopAnimating()
            let singleMedian = result.count == 1
            let prefix = singleMedian ? "The Median Prime is:" : "The Median Primes are:"
            let primes = singleMedian ? "\(result[0])" : "\(result[0]), \(result[1])"
            resultLabelView.label.text = "\(prefix) \(primes)"
            resultLabelView.isHidden = false
        case .error(let error):
            spinnerView.stopAnimating()
            switch error {
            case .missingParameter:
                errorLabelView.label.text = "Please enter a valid upper limit."
            case .invalidParameterType:
                errorLabelView.label.text = "Please enter a valid positive integer as the upper limit."
            case .invalidValue(let required):
                let message = required == 2 ? "greater than 2." : "less than 100 million."
                errorLabelView.label.text = "Please enter a number \(message)"
            case .unknown(_):
                errorLabelView.label.text = "An error occured. Please try again."
            }
            errorLabelView.isHidden = false
        }
    }

    func setupView() {
        view.backgroundColor = UIColor(hex: 0xf5f5f5)
        
        view.addSubview(upperLimitTextField)
        upperLimitTextField.centerYToSuperview()
        let leadingConstraint = upperLimitTextField.leadingToSuperview(offset: 30, usingSafeArea: true)
        let trailingConstraint = upperLimitTextField.trailingToSuperview(offset: 30, usingSafeArea: true)
        upperLimitTextField.height(40)
        
        view.addSubview(upperLimitLabel)
        upperLimitLabel.leadingToSuperview(offset: leadingConstraint.constant, usingSafeArea: true)
        upperLimitLabel.bottomToTop(of: upperLimitTextField, offset: -5)
        
        view.addSubview(subtitleLabel)
        subtitleLabel.leadingToSuperview(offset: leadingConstraint.constant, usingSafeArea: true)
        subtitleLabel.bottomToTop(of: upperLimitLabel, offset: -20)
        
        view.addSubview(titleLabel)
        titleLabel.leadingToSuperview(offset: leadingConstraint.constant, usingSafeArea: true)
        titleLabel.bottomToTop(of: subtitleLabel, offset: -20)
        
        view.addSubview(calculateButton)
        calculateButton.leadingToSuperview(offset: leadingConstraint.constant, usingSafeArea: true)
        calculateButton.topToBottom(of: upperLimitTextField, offset: 10)
        calculateButton.width(80)
        calculateButton.height(35)
        
        view.addSubview(resultLabelView)
        resultLabelView.leadingToSuperview(offset: leadingConstraint.constant, usingSafeArea: true)
        resultLabelView.trailingToSuperview(offset: -trailingConstraint.constant, usingSafeArea: true)
        resultLabelView.topToBottom(of: calculateButton, offset: 10)
        resultLabelView.height(50)
        
        view.addSubview(errorLabelView)
        errorLabelView.leadingToSuperview(offset: leadingConstraint.constant, usingSafeArea: true)
        errorLabelView.trailingToSuperview(offset: -trailingConstraint.constant, usingSafeArea: true)
        errorLabelView.topToBottom(of: calculateButton, offset: 10)
        errorLabelView.height(50)
        
        view.addSubview(spinnerView)
        spinnerView.centerXToSuperview()
        spinnerView.topToBottom(of: calculateButton, offset: 15)
    }
}
