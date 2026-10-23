import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Permission.View.Controller {
    struct Default:
        Interface
    {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Permission.View.Interactor.Interface,
                any Permission.View.Presenter.Interface
            >

        func getSystemPermission(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
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
            catch let error
                as Permission.View.Error
            {
                return try await presenter.renderErrorPage(error: error)
            }
        }
    }
}
