import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension MenuItem.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any MenuItem.View.Interactor.Interface,
                any MenuItem.View.Presenter.Interface
            >

        func getMenuItem(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let menuId = try context.requiredID()
            let id = try context.requiredParameter("itemId")
            let permissions = context.currentUserPermissions
            do {
                let model = try await runtime.interactor.execute(
                    input: .init(menuId: menuId, id: id)
                )
                return try await runtime.presenter.renderDetailsPage(
                    model: model,
                    permissions: permissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter.renderErrorPage(
                    menuId: menuId,
                    info: error.errorTitle,
                    message: error.errorDescription,
                    permissions: permissions
                )
            }
        }
    }
}
