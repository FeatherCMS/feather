import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.View.Controller {
    struct Default:
        WebAdmin.System.Permission.View.Controller.Interface
    {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any WebAdmin.System.Permission.View.Interactor.Interface,
                any WebAdmin.System.Permission.View.Presenter.Interface
            >

        func getSystemPermission(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (interactor, presenter) = buildRuntime((request, context))
            guard
                context.isCurrentUserAllowed(
                    to: SystemModule.Permission.Permissions.read
                )
            else {
                return try await presenter.renderErrorPage(error: .forbidden)
            }
            let id = try context.requiredID()
            do {
                let permission = try await interactor.execute(
                    entity: .init(id: id)
                )
                return try await presenter.renderDetailsPage(
                    permission: permission,
                    permissions: context.currentUserAdminListActions
                )
            }
            catch let error as WebAdmin.System.Permission.View.Error {
                return try await presenter.renderErrorPage(error: error)
            }
        }
    }
}
