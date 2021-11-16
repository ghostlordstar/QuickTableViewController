//
//  InputText.swift
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

public struct InputText: Equatable {
  
  private var methodSignature: String
  public var text: String?
  public var placeHolderText: String?
  public var placeHolderAttributeText: NSAttributedString?
  public var clearButtonMode: UITextField.ViewMode = .whileEditing
  
  private init(methodSignature: String, text: String?, placeHolderText: String?, placeHolderAttributeText: NSAttributedString?, clearButtonMode: UITextField.ViewMode? = .whileEditing) {
    self.methodSignature = methodSignature
    self.text = text ?? ""
    self.placeHolderText = placeHolderText
    self.placeHolderAttributeText = placeHolderAttributeText
    self.clearButtonMode = clearButtonMode ?? .whileEditing
  }
  
  public static func text(_ text: String?, placeholderText: String? = nil, clearButtonMode: UITextField.ViewMode? = nil) -> Self {
    return InputText.init(methodSignature: #function, text: text, placeHolderText: placeholderText, placeHolderAttributeText: nil, clearButtonMode: clearButtonMode)
  }
  
  public static func text(_ text: String?, placeholderText: NSAttributedString? = nil, clearButtonMode: UITextField.ViewMode? = nil) -> Self {
    return InputText.init(methodSignature: #function, text: text, placeHolderText: nil, placeHolderAttributeText: placeholderText, clearButtonMode: clearButtonMode)
  }
  
  public func textValue() -> String? {
    return self.text
  }
  
  mutating func update(text: String?) -> Self {
    self.text = text ?? ""
    return self
  }
}
