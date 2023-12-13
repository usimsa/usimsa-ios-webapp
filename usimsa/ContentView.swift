//
//  ContentView.swift
//  webView
//
//  Created by 연주 on 2023/02/03.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MyWebView(urlToLoad: "https://www.usimsa.com")
            .edgesIgnoringSafeArea(.all)
            .scrollIndicators(/*@START_MENU_TOKEN@*/.never/*@END_MENU_TOKEN@*/, axes: /*@START_MENU_TOKEN@*/[.vertical, .horizontal]/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
