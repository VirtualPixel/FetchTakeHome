//
//  AlertItem.swift
//  FetchTakeHome
//
//  Created by Justin Wells on 1/30/25.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}
