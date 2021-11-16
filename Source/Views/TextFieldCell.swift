//
//  TextFieldCell.swift
//  QuickTableViewController
//
//  Created by Hansen on 2021/11/12.
//  Copyright © 2021 bcylin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

public protocol TextFieldCellDelegate: AnyObject {
  /// Tells the delegate that the textField did changed.
  func textFieldCell(_ cell: TextFieldCell, didChanged text: String?)
}

open class TextFieldCell: UITableViewCell {
  
  private var lastInputText: String?
  
  public private(set) lazy var textField: UITextField = {
    let textField = UITextField()
    textField.delegate = self
    return textField
  }()
  
  open weak var delegate: TextFieldCellDelegate?
  
  // MARK: - Initializer
  
  /**
   Overrides `UITableViewCell`'s designated initializer.
   
   - parameter style:           A constant indicating a cell style.
   - parameter reuseIdentifier: A string used to identify the cell object if it is to be reused for drawing multiple rows of a table view.
   
   - returns: An initialized `SwitchCell` object.
   */
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUpAppearance()
  }
  
  /**
   Overrides the designated initializer that returns an object initialized from data in a given unarchiver.
   
   - parameter aDecoder: An unarchiver object.
   
   - returns: `self`, initialized using the data in decoder.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpAppearance()
  }
  
  // MARK: - Private
  
  @objc private func textDidChangeNoti() {
    self.checkTextChanged(text: self.textField.text)
  }
  
  private func checkTextChanged(text: String?) {
    if text != self.lastInputText {
      self.lastInputText = text
      self.delegate?.textFieldCell(self, didChanged: self.lastInputText)
    }
  }
  
  private func setUpAppearance() {
    textLabel?.numberOfLines = 0
    detailTextLabel?.numberOfLines = 0
    NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeNoti), name: UITextField.textDidChangeNotification, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
  }
}


extension TextFieldCell: Configurable {
  public func configure(with row: Row & RowStyle) {
    self.textLabel?.sizeToFit()
    self.detailTextLabel?.text = ""
    self.textField.text = row.inputText?.textValue()
    self.textField.clearButtonMode = row.inputText?.clearButtonMode ?? .whileEditing
    if let placeHolder = row.inputText?.placeHolderText, !placeHolder.isEmpty {
      self.textField.placeholder = placeHolder
    }else if let placeHolder = row.inputText?.placeHolderAttributeText, !placeHolder.string.isEmpty {
      self.textField.attributedPlaceholder = placeHolder
    }
    self.contentView.addSubview(self.textField)
    if let titleLabel = self.textLabel{
      self.textField.translatesAutoresizingMaskIntoConstraints = false
      self.textField.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20 + titleLabel.frame.size.width + 10).isActive = true
      self.textField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
      self.textField.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
  }
}

extension TextFieldCell: UITextFieldDelegate {
  public func textFieldDidEndEditing(_ textField: UITextField) {
    self.checkTextChanged(text: textField.text)
  }
}
