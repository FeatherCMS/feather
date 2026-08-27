import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AppGetStylesheetDefaultController: AppGetStylesheetController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AppGetStylesheetInteractor,
            presenter: any AppGetStylesheetPresenter
        )

    func getStyleCSS(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> CSSResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        return presenter.render(css: try await interactor.getStyleCSS())
    }
}
