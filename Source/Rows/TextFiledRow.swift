//
//  TextFieldRow.swift
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

/// A class that represents a row with a textfield.
open class TextFieldRow<T: TextFieldCell>: TextFieldRowCompatible, Equatable {
  
  public var detailText: DetailText?
  
  public var inputText: InputText?
  
  // MARK: - Initializer
  
  /// Initializes a `TextFieldRow` with a title and an action closure.
  /// The inputText, icon and the customization closure are optional.
  public init(
    text: String,
    inputText: InputText? = nil,
    icon: Icon? = nil,
    customization: ((UITableViewCell, Row & RowStyle) -> Void)? = nil,
    action: ((Row) -> Void)?
  ) {
    self.text = text
    self.inputText = inputText
    self.icon = icon
    self.customize = customization
    self.action = action
    self.inputTextValue = self.inputText?.textValue()
  }
  
  // MARK: - TextFieldRowCompatible
  public var inputTextValue: String? {
    didSet {
      guard self.inputTextValue != oldValue else { return }
      DispatchQueue.main.async {
        self.inputText = self.inputText?.update(text: self.inputTextValue)
        self.action?(self)
      }
    }
  }
  
  // MARK: - Row
  
  /// The text of the row.
  public let text: String
  
  /// A closure that will be invoked when the `inputText` is changed.
  public let action: ((Row) -> Void)?
  
  // MARK: - RowStyle
  
  /// The type of the table view cell to display the row.
  public let cellType: UITableViewCell.Type = T.self
  
  /// Returns the reuse identifier of the table view cell to display the row.
  public var cellReuseIdentifier: String {
    return T.reuseIdentifier + text
  }
  
  /// Returns the table view cell style for the specified detail text.
  public var cellStyle: UITableViewCell.CellStyle {
    return detailText?.style ?? .default
  }
  
  /// The icon of the row.
  public let icon: Icon?
  
#if os(iOS)
  
  /// The default accessory type is `.none`.
  public let accessoryType: UITableViewCell.AccessoryType = .none
  
  /// The `TextFieldRow` should not be selectable.
  public let isSelectable: Bool = false
  
#elseif os(tvOS)
  
  /// Returns `.checkmark` when the `switchValue` is on, otherwise returns `.none`.
  public var accessoryType: UITableViewCell.AccessoryType {
    return .none
  }
  
  /// The `TextFieldRow` is selectable on tvOS.
  public let isSelectable: Bool = true
  
#endif
  
  /// The additional customization during cell configuration.
  public let customize: ((UITableViewCell, Row & RowStyle) -> Void)?
  
  // MARK: - Equatable
  
  /// Returns true iff `lhs` and `rhs` have equal titles, detail texts, switch values, and icons.
  public static func == (lhs: TextFieldRow, rhs: TextFieldRow) -> Bool {
    return lhs.text == rhs.text &&
    lhs.inputText == rhs.inputText &&
    lhs.icon == rhs.icon
  }
  
}
