import SwiftUI
import WebKit

struct PresentationWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false

        guard let presentationURL = Bundle.main.url(
            forResource: "index",
            withExtension: "html",
            subdirectory: "Presentation"
        ) else {
            loadError(in: webView, message: "Could not find Presentation/index.html in the app bundle. Run setup.sh first.")
            return webView
        }

        webView.loadFileURL(
            presentationURL,
            allowingReadAccessTo: presentationURL.deletingLastPathComponent()
        )
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator() }

    private func loadError(in webView: WKWebView, message: String) {
        let html = """
        <html>
        <body style="background:#1a1a2e;color:#e94560;font-family:system-ui;padding:3rem;">
        <h1>Presentation Not Found</h1>
        <p>\(message)</p>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            NSLog("Navigation failed: %@", error.localizedDescription)
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            NSLog("Provisional navigation failed: %@", error.localizedDescription)
            let html = """
            <html>
            <body style="background:#1a1a2e;color:#e94560;font-family:system-ui;padding:3rem;">
            <h1>Load Error</h1>
            <p>\(error.localizedDescription)</p>
            </body>
            </html>
            """
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
}
