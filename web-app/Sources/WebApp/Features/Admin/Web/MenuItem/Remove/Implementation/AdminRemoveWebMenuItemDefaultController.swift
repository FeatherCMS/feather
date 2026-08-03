import HTML
import Hummingbird

struct AdminRemoveWebMenuItemDefaultController:
    AdminRemoveWebMenuItemController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveWebMenuItemInteractor,
            presenter: any AdminRemoveWebMenuItemPresenter
        )

    func getRemoveWebMenuItem(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let id = try context.requiredParameter("itemId")
        let permissions = context.currentUserPermissions

        do {
            let rule = try await runtime.interactor.get(menuId: menuId, id: id)
            return runtime.presenter.renderRemovePage(
                menuId: menuId,
                id: id,
                label: rule.label,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return runtime.presenter.renderErrorPage(
                menuId: menuId,
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }

    func postRemoveWebMenuItem(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let id = try context.requiredParameter("itemId")
        let permissions = context.currentUserPermissions

        do {
            try await runtime.interactor.delete(menuId: menuId, id: id)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/web/menus/\(menuId)/items/",
                        title: "Removed",
                        message: "Item removed successfully."
                    )
                ]
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try runtime.presenter
                .renderErrorPage(
                    menuId: menuId,
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }
}
