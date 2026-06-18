import Hummingbird

struct AppGetHomeDefaultController: AppGetHomeController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AppGetHomeInteractor,
            presenter: any AppGetHomePresenter
        )

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let model = try await interactor.getHome(account: context.account)
        return presenter.renderPage(model: model)
    }
}
