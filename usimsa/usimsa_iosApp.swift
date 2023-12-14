//
//  usimsa_iosApp.swift
//  usimsa-ios
//
//  Created by 연주 on 2023/12/13.
//

import SwiftUI

@main
struct usimsa_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
