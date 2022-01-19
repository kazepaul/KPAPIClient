//
//  ViewUtils.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2022/01/15.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
