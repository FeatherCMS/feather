import FeatherAdmin
import Foundation
import Hummingbird

struct AppPublicContentDefaultController: AppPublicContentController {

    let usesSecureCookies: Bool
    let buildRuntime:
        RuntimeBuilder<
            any AppPublicContentInteractor,
            any AppPublicContentPresenter
        >

    func getContent(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))

        let slug = request.uri.path.trimmingCharacters(
            in: CharacterSet(charactersIn: "/")
        )
        let content = try await interactor.resolve(slug: slug)
        let formSubmissionNonce = WebFormSubmissionNonce.resolve(
            existingCookieValue: request.cookies[
                WebFormSubmissionNonce.cookieName
            ]?.value
        )
        let formSubmissionFeedback = WebFormSubmissionFeedback(
            source: request.uri.queryParameters[
                Substring(WebFormSubmissionFeedback.sourceQueryKey)
            ].map(String.init),
            key: request.uri.queryParameters[
                Substring(WebFormSubmissionFeedback.keyQueryKey)
            ].map(String.init),
            status: request.uri.queryParameters[
                Substring(WebFormSubmissionFeedback.statusQueryKey)
            ].map(String.init)
        )
        let rendered = await presenter.render(
            content: content,
            formSubmissionNonce: formSubmissionNonce,
            formSubmissionFeedback: formSubmissionFeedback
        )
        let hasFormSubmissionNonce = rendered.usesFormSubmissionNonce
        let cookies = hasFormSubmissionNonce
            ? [WebFormSubmissionNonce.cookie(
                value: formSubmissionNonce,
                secure: usesSecureCookies
            )]
            : []
        let response = HTMLResponse(
            content: rendered.response.content,
            status: content.status,
            cookies: cookies
        )
        var result = try response.response(from: request, context: context)
        if hasFormSubmissionNonce {
            result.headers[.cacheControl] = "no-store"
        }
        return result
    }
}
