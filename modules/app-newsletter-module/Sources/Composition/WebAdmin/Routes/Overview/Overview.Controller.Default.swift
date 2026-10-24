import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Overview.Interactor.Interface,
                any Overview.Presenter.Interface
            >

        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            return try await runtime.presenter.renderOverview(
                model: try await runtime.interactor.getOverview(),
                permissions: context.currentUserPermissions
            )
        }
    }
}
