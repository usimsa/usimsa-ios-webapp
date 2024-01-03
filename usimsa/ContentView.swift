//
//  ContentView.swift
//  webView
//
//  Created by 연주 on 2023/12/13.
//

import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        MyWebView(urlToLoad: "https://www.usimsa.com", showAlert: $showAlert, alertMessage: $alertMessage)
            .scrollIndicators(.never, axes: [.vertical, .horizontal])
            .alert(isPresented: $showAlert) {
                Alert(title: Text("결제실패"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
