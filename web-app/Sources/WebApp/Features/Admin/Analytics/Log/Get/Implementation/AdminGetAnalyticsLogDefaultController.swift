import HTML
import Hummingbird

struct AdminGetAnalyticsLogDefaultController: AdminGetAnalyticsLogController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetAnalyticsLogInteractor,
            presenter: any AdminGetAnalyticsLogPresenter
        )

    func getAnalyticsLog(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        do {
            let model = try await interactor.execute(id: id)
            return presenter.renderPage(
                model: model,
                permissions: context.currentUserPermissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderErrorPage(
                id: id,
                error: error,
                permissions: context.currentUserPermissions
            )
        }
    }
}
