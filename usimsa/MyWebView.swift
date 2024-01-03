//
//  myWebView.swift
//  webView
//
//  Created by 연주 on 2023/12/13.
//

import SwiftUI
import WebKit

// uikit의 uiview를 사용할 수 있도록 하는 것
// UIViewControllerRepresentable
struct MyWebView: UIViewRepresentable {

    var urlToLoad: String
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    
    // ui view 만들기
    func makeUIView(context: Context) -> some WKWebView {
        
        // webview instance 생성
        let webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        
        // userAgent 설정: userAgent 값을 가져온 후 커스텀 값을 추가
        webview.evaluateJavaScript("navigator.userAgent") { (result, error) in
            if let userAgent = result as? String {
                let customUserAgent = userAgent + " APP_USIMSA"
                
                // 실제 사용하는 webView에 설정
                webview.customUserAgent = customUserAgent

                // 이제 URL 로드
                if let url = URL(string: self.urlToLoad) {
                    webview.load(URLRequest(url: url))
                }
            }
        }
        
        webview.uiDelegate = context.coordinator // UI 대리자 설정
        webview.navigationDelegate = context.coordinator // 내비게이션 대리자 설정
        // 스와이프 제스쳐
        webview.allowsBackForwardNavigationGestures = true
        
        return webview
    }
    
    // 업데이트 ui view
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<MyWebView>) {
    }

    func makeCoordinator() -> Coordinator {
            Coordinator(self, showAlert: $showAlert, alertMessage: $alertMessage)
        }

        class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
            var parent: MyWebView
            var allowedURLSchemes: [String] = []
            var showAlert: Binding<Bool>
            var alertMessage: Binding<String>

            init(_ parent: MyWebView, showAlert: Binding<Bool>, alertMessage: Binding<String>) {
                self.parent = parent
                self.showAlert = showAlert
                self.alertMessage = alertMessage
                super.init()
                loadAllowedURLSchemes()
            }
            
            private func loadAllowedURLSchemes() {
                if let schemes = Bundle.main.object(forInfoDictionaryKey: "LSApplicationQueriesSchemes") as? [String] {
                    allowedURLSchemes = schemes
                }
            }

            
            func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
                guard let url = navigationAction.request.url, let scheme = url.scheme else {
                    decisionHandler(.allow)
                    return
                }

                // 'mailto' 스킴 처리
                if url.scheme == "mailto" {
                    UIApplication.shared.open(url)
                    decisionHandler(.cancel)
                    return
                }

                // 다른 앱을 여는 커스텀 URL 스킴 처리 (예: 'appusimsa://')
                if allowedURLSchemes.contains(scheme) {
                    handleCustomScheme(url)
                    decisionHandler(.cancel)
                    return
                }

                // 기본적인 웹 뷰 탐색 계속
                decisionHandler(.allow)
            }
            
            private func handleCustomScheme(_ url: URL) {
                // 커스텀 URL 스킴 처리
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                        // 유효하지 않은 URL 처리
                    alertMessage.wrappedValue = "선택하신 카드의 결제앱이 설치되어있지 않습니다."
                    showAlert.wrappedValue = true
                }
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
    @State static var showAlert = false
    @State static var alertMessage = ""

    static var previews: some View {
        MyWebView(urlToLoad: "https://www.usimsa.com", showAlert: $showAlert, alertMessage: $alertMessage)
            .edgesIgnoringSafeArea(.bottom)
            .scrollIndicators(.never, axes: [.vertical, .horizontal])
    }
}
