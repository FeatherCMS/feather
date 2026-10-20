import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Overview.Controller {
    struct Default:
        WebAdmin.System.Overview.Controller.Interface
    {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any WebAdmin.System.Overview.Interactor.Interface,
                any WebAdmin.System.Overview.Presenter.Interface
            >

        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (interactor, presenter) = buildRuntime((request, context))
            let model = try await interactor.getOverview()
            return try await presenter.renderOverview(
                model: model,
                permissions: context.currentUserPermissions
            )
        }
    }
}
