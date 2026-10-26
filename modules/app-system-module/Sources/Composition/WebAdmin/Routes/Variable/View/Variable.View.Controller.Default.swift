import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SystemModule

extension Variable.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Variable.View.Interactor.Interface,
                any Variable.View.Presenter.Interface
            >

        func getSystemVariable(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
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
            catch let error as Variable.View.Error {
                return try await runtime.presenter.renderErrorPage(
                    error: error
                )
            }
        }
    }
}
