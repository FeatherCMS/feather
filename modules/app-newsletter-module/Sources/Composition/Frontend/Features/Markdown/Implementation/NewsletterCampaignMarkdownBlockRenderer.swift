import Foundation
import WebFrontend

struct NewsletterCampaignMarkdownBlockRenderer: WebMarkdownBlockRenderer {
    let name = "NewsletterCampaign"

    func render(
        request: WebMarkdownBlockRendererRequest
    ) async -> String? {
        guard let identifier = request.arguments["id"] else { return nil }
        guard !identifier.isEmpty else { return nil }
        return
            "<form method=\"post\" action=\"/newsletter/campaigns/\(escape(identifier))/subscribe\" class=\"newsletter-subscription-form\"><label for=\"newsletter-campaign-\(escape(identifier))\">Email</label><input type=\"email\" id=\"newsletter-campaign-\(escape(identifier))\" name=\"email\" required><button type=\"submit\">Subscribe</button></form>"
    }

    private func escape(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }
}
