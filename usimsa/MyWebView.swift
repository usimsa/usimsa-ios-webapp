//
//  myWebView.swift
//  webView
//
//  Created by 연주 on 2023/02/03.
//

import SwiftUI
import WebKit

// uikit의 uiview를 사용할 수 있도록 하는 것
// UIViewControllerRepresentable
struct MyWebView: UIViewRepresentable {

    var urlToLoad: String
    
    // ui view 만들기
    func makeUIView(context: Context) -> some WKWebView {
        
        // unwrapping
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        
        // webview instance 생성
        let webview = WKWebView()
        webview.uiDelegate = context.coordinator // UI 대리자 설정
        webview.navigationDelegate = context.coordinator // 내비게이션 대리자 설정
        
        // 웹뷰 로드
        webview.load(URLRequest(url: url))
        
        // userAgent 설정
        let userAgent = WKWebView().value(forKey: "userAgent")
        webview.customUserAgent = userAgent as! String + "APP_USIMSA"
        
        // 스와이프 제스쳐
        webview.allowsBackForwardNavigationGestures = true
        
        return webview
    }
    
    // 업데이트 ui view
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<MyWebView>) {
    }

    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
            var parent: MyWebView

            init(_ parent: MyWebView) {
                self.parent = parent
            }

            // 새 창 열기 처리
            func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
                // 새 창이나 팝업 링크의 경우 현재 웹뷰에서 로드
                if navigationAction.targetFrame == nil || !(navigationAction.targetFrame!.isMainFrame) {
                    webView.load(navigationAction.request)
                }
                return nil
            }
            // 필요에 따라 추가 WKUIDelegate 및 WKNavigationDelegate 메소드 구현
        }
  
    
}

struct MyWebView_Previews: PreviewProvider {
    static var previews: some View {
        MyWebView(urlToLoad: "https://www.usimsa.com")
            .edgesIgnoringSafeArea(.bottom)
            .scrollIndicators(.never, axes: [.vertical, .horizontal])
    }
}

