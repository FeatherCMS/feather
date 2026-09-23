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
        let content = try await interactor.resolve(slug: slug)
        let rendered = await presenter.render(
            content: content
        )
        let response = HTMLResponse(
            content: rendered.content,
            status: content.status
        )
        return try response.response(from: request, context: context)
    }
}
