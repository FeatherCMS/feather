import FeatherWebApp
import FeatherWebShared
import Foundation
import Hummingbird
import NIOCore

struct AppPublicContentDefaultController: AppPublicContentController {

    let usesSecureCookies: Bool
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> WebAppRuntime<
            any AppPublicContentInteractor,
            any AppPublicContentPresenter
        >

    func getRSS(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let content = try await buildRSS(request: request, context: context)
        return .init(
            status: .ok,
            headers: [.contentType: "application/rss+xml; charset=utf-8"],
            body: .init(byteBuffer: ByteBuffer(string: content))
        )
    }

    func getSitemap(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let content = try await buildSitemap(request: request, context: context)
        return .init(
            status: .ok,
            headers: [.contentType: "application/xml; charset=utf-8"],
            body: .init(byteBuffer: ByteBuffer(string: content))
        )
    }

    func getContent(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter

        let slug = request.uri.path.trimmingCharacters(
            in: CharacterSet(charactersIn: "/")
        )
        let content = try await interactor.resolve(slug: slug)
        let formSubmissionNonce = FormSubmissionNonce.resolve(
            existingCookieValue: request.cookies[
                FormSubmissionNonce.cookieName
            ]?
            .value
        )
        let formSubmissionFeedback = FormSubmissionFeedback(
            source: request.uri
                .queryParameters[
                    Substring(FormSubmissionFeedback.sourceQueryKey)
                ]
                .map(String.init),
            key: request.uri
                .queryParameters[
                    Substring(FormSubmissionFeedback.keyQueryKey)
                ]
                .map(String.init),
            status: request.uri
                .queryParameters[
                    Substring(FormSubmissionFeedback.statusQueryKey)
                ]
                .map(String.init)
        )
        let rendered = await presenter.render(
            content: content,
            formSubmissionNonce: formSubmissionNonce,
            formSubmissionFeedback: formSubmissionFeedback
        )
        let hasFormSubmissionNonce = rendered.usesFormSubmissionNonce
        let cookies =
            hasFormSubmissionNonce
            ? [
                FormSubmissionNonce.cookie(
                    value: formSubmissionNonce,
                    secure: usesSecureCookies
                )
            ]
            : []
        let response = WebAppHTMLResponse(
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

    private func buildRSS(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> String {
        let __runtimeBuild2 = buildRuntime(request, context)
        let interactor = __runtimeBuild2.interactor
        let presenter = __runtimeBuild2.presenter
        let model = try await interactor.resolveRSS()
        return presenter.renderRSS(model: model)
    }

    private func buildSitemap(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> String {
        let __runtimeBuild3 = buildRuntime(request, context)
        let interactor = __runtimeBuild3.interactor
        let presenter = __runtimeBuild3.presenter
        let model = try await interactor.resolveSitemap()
        return presenter.renderSitemap(model: model)
    }
}
