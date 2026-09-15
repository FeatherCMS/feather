import FeatherAdmin
import HTML
import Hummingbird

struct AdminViewAnalyticsLogDefaultController: AdminViewAnalyticsLogController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewAnalyticsLogInteractor,
            presenter: any AdminViewAnalyticsLogPresenter
        )

    func getAnalyticsLog(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        do {
            let model = try await interactor.execute(id: id)
            return try await presenter.renderPage(
                model: model,
                permissions: context.currentUserPermissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderErrorPage(
                id: id,
                error: error,
                permissions: context.currentUserPermissions
            )
        }
    }
}
