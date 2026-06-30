import SwiftUI
import WebKit

struct PresentationWebView: NSViewRepresentable {
    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "developerExtrasEnabled")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.setValue(false, forKey: "drawsBackground")

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

    func updateNSView(_ nsView: WKWebView, context: Context) {}

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
