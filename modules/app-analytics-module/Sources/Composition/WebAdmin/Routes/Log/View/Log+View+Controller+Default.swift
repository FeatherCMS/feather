import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Log.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Log.View.Interactor.Interface,
                any Log.View.Presenter.Interface
            >

        func getAnalyticsLog(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
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
}
