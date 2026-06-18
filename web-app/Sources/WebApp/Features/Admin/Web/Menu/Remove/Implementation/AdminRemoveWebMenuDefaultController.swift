import HTML
import Hummingbird

struct AdminRemoveWebMenuDefaultController:
    AdminRemoveWebMenuController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveWebMenuInteractor,
            presenter: any AdminRemoveWebMenuPresenter
        )

    func getRemoveWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            let menu = try await runtime.interactor.get(id: id)
            return runtime.presenter.renderRemovePage(
                id: id,
                source: menu.name,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return runtime.presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }

    func postRemoveWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            try await runtime.interactor.delete(id: id)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/web/menus/",
                        title: "Removed",
                        message: "Menu removed successfully."
                    )
                ]
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try runtime.presenter
                .renderErrorPage(
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }
}
