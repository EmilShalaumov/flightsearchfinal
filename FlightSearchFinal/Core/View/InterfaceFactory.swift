//
//  InterfaceFactory.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import UIKit

class InterfaceFactory {
    
    /// Default line / background color
    let lineColor = UIColor(red: 228 / 255, green: 244 / 255, blue: 1, alpha: 1)
    let categoryColor: UIColor = .white
    let cornerRadius: CGFloat = 5
    
    /// Default date format for design template
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, yyyy"
        return formatter
    }()
    
    /// Creates view with text field and image on the left, text field is unable for editing
    ///
    /// - Parameters:
    ///   - img: Image string identifier
    ///   - placeholder: Placeholder of text field
    ///   - tag: Tag to identify the field
    /// - Returns: View with text field and image
    func createTextFieldWithImage(img: String?, placeholder: String, tag: Int) -> TextWithImage {
        let view = TextWithImage()
        view.textField.tag = tag
        view.textField.textColor = .black
        view.textField.placeholder = placeholder
        view.textField.delegate = view
        if let img = img {
            view.imageView.image = UIImage(named: img)
        }
        return view
    }
    
    /// Creates view with text field and image on the left, text field is available for editing
    ///
    /// - Parameters:
    ///   - img: Image string identifier
    ///   - placeholder: Placeholder of text field
    /// - Returns: View with text field and image
    func createEditableTextFieldWithImage(img: String?, placeholder: String) -> TextWithImage {
        let view = TextWithImage()
        view.textField.textColor = .black
        view.textField.placeholder = placeholder
        view.textField.autocorrectionType = .no
        if let img = img {
            view.imageView.image = UIImage(named: img)
        }
        return view
    }
    
    /// Creates line view with height equals to 1
    ///
    /// - Returns: View as line
    func createLine() -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = lineColor
        lineView.setHeightAnchor(constant: 1)
        return lineView
    }
}

class TextWithImage: UIControl, UITextFieldDelegate {
    /// Image of field, shows on the left
    var imageView = UIImageView()
    /// Text to show on the right
    var textField = UITextField()
    
    init() {
        super.init(frame: .zero)
        
        textField.textColor = .black
        
        addSubview(imageView)
        addSubview(textField)
        
        imageView.setLeftAnchor(equalTo: leftAnchor, constant: 18)
        imageView.setWidthAnchor(constant: 18)
        imageView.setHeightAnchor(constant: 18)
        imageView.setCenterYAnchor(equalTo: textField.centerYAnchor)
        
        textField.setLeftAnchor(equalTo: imageView.rightAnchor, constant: 18)
        textField.setRightAnchor(equalTo: rightAnchor)
        textField.setTopAnchor(equalTo: topAnchor)
        textField.setBottomAnchor(equalTo: bottomAnchor)
        textField.setHeightAnchor(constant: 68)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
