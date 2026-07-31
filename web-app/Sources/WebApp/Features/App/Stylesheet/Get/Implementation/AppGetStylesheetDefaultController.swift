import Hummingbird

struct AppGetStylesheetDefaultController: AppGetStylesheetController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AppGetStylesheetInteractor,
            presenter: any AppGetStylesheetPresenter
        )

    func getStyleCSS(
        request: Request,
        context: AppRequestContext
    ) async throws -> CSSResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        return presenter.render(css: try await interactor.getStyleCSS())
    }
}
