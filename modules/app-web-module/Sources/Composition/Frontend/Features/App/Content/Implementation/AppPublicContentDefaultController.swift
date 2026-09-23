import FeatherAdmin
import Hummingbird
import Foundation

struct AppPublicContentDefaultController: AppPublicContentController {

    let buildRuntime: RuntimeBuilder<
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
        guard let content = try await interactor.resolve(slug: slug) else {
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
