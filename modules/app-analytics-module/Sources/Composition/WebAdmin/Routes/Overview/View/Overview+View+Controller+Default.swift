import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Overview.View.Interactor.Interface,
                any Overview.View.Presenter.Interface
            >

        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let model = try await runtime.interactor.getOverview()
            return try await runtime.presenter.renderOverview(
                model: model,
                permissions: context.currentUserPermissions
            )
        }
    }
}
