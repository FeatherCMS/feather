import FeatherWebApp
import Hummingbird

protocol AppPublicContentPresenter: Sendable {

    func render(
        content: AppPublicContentModel,
        formSubmissionNonce: String,
        formSubmissionFeedback: WebFormSubmissionFeedback?
    ) async -> (response: WebAppHTMLResponse, usesFormSubmissionNonce: Bool)

    func renderRSS(model: AppPublicRSSModel) -> String

    func renderSitemap(model: AppPublicSitemapModel) -> String
}
