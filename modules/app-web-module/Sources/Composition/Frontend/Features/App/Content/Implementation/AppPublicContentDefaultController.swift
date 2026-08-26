import FeatherAdmin
import Hummingbird

struct AppPublicContentDefaultController: AppPublicContentController {

    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AppPublicContentInteractor,
            presenter: any AppPublicContentPresenter
        )

    func getContent(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        try await render(
            path: request.uri.path,
            request: request,
            context: context
        )
    }
}

extension AppPublicContentDefaultController {

    fileprivate func render(
        path: String,
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard let content = try await interactor.resolve(path: path) else {
            throw HTTPError(.notFound)
        }
        let rendered = await presenter.render(
            content: content,
            request: request
        )
        let response = HTMLResponse(
            content: rendered.content,
            status: content.isNotFound ? .notFound : .ok
        )
        return try response.response(from: request, context: context)
    }
}
