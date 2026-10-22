import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any WebModule.Menu.View.Interactor.Interface,
                any WebModule.Menu.View.Presenter.Interface
            >

        func getMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime((request, context))
            let id = try context.requiredID()
            let permissions = context.currentUserPermissions
            do {
                let rule = try await runtime.interactor.execute(
                    input: .init(
                        id: id
                    )
                )
                return try await runtime.presenter.renderDetailsPage(
                    rule: rule,
                    permissions: permissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter.renderErrorPage(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    permissions: permissions
                )
            }
        }
    }
}
