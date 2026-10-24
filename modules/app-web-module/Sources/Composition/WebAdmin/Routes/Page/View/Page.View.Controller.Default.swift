import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Page.View.Interactor.Interface,
                any Page.View.Presenter.Interface
            >

        func getPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            let permissions = context.currentUserAdminListActions
            do {
                let rule = try await runtime.interactor.execute(
                    entity: Page.View.Input(id: id)
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
