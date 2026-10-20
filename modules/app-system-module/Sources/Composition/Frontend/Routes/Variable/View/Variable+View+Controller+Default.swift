import FeatherAdmin
import HTML
import Hummingbird
import SystemModule

extension WebAdmin.System.Variable.View.Controller {
    struct Default:
        WebAdmin.System.Variable.View.Controller.Interface
    {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any WebAdmin.System.Variable.View.Interactor.Interface,
                any WebAdmin.System.Variable.View.Presenter.Interface
            >

        func getSystemVariable(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime((request, context))
            guard
                context.isCurrentUserAllowed(
                    to: SystemModule.Variable.Permissions.read
                )
            else {
                return try await runtime.presenter.renderErrorPage(
                    error: .forbidden
                )
            }
            let id = try context.requiredID()
            do {
                let variable = try await runtime.interactor.execute(
                    entity: .init(id: id)
                )
                return try await runtime.presenter.renderDetailsPage(
                    variable: variable,
                    permissions: context.currentUserAdminListActions,
                )
            }
            catch let error as WebAdmin.System.Variable.View.Error {
                return try await runtime.presenter.renderErrorPage(
                    error: error
                )
            }
        }
    }
}
