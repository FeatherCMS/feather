import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Contact.Overview.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Contact.Overview.Interactor.Interface,
                any Contact.Overview.Presenter.Interface
            >

        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            return try await presenter.renderOverview(
                model: try await interactor.getOverview(),
                permissions: context.currentUserPermissions
            )
        }
    }
}
