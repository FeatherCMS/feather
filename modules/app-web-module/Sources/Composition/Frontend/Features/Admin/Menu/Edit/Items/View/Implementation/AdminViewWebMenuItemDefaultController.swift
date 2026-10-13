import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebMenuItemDefaultController: AdminViewWebMenuItemController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewWebMenuItemInteractor,
            any AdminViewWebMenuItemPresenter
        >

    func getWebMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime((request, context))
        let menuId = try context.requiredID()
        let id = try context.requiredParameter("itemId")
        let permissions = context.currentUserPermissions
        do {
            let rule = try await runtime.interactor.execute(
                entity: .init(menuId: menuId, id: id)
            )
            return try await runtime.presenter.renderDetailsPage(
                rule: rule,
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
