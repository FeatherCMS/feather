import FeatherWebApp
import Hummingbird

extension Public.Content {
    enum Presenter {}
}

extension Public.Content.Presenter {
    protocol Interface: Sendable {
        func render(
            content: Public.Content.Model,
            formSubmissionNonce: String,
            formSubmissionFeedback: FormSubmissionFeedback?
        ) async -> Output

        func renderRSS(model: Public.RSS.Model) -> String

        func renderSitemap(model: Public.Sitemap.Model) -> String
    }
}
