import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

struct AdminViewAnalyticsLogDefaultController: AdminViewAnalyticsLogController {
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminViewAnalyticsLogInteractor,
            any AdminViewAnalyticsLogPresenter
        >

    func getAnalyticsLog(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
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
