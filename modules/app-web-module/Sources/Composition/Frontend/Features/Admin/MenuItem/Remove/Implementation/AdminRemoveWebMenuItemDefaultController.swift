import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveWebMenuItemDefaultController:
    AdminRemoveWebMenuItemController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveWebMenuItemInteractor,
            presenter: any AdminRemoveWebMenuItemPresenter
        )

    func getRemoveWebMenuItem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let id = try context.requiredParameter("itemId")
        do {
            let rule = try await runtime.interactor.get(menuId: menuId, id: id)
            return try await runtime.presenter.renderRemovePage(
                menuId: menuId,
                item: .init(id: id, label: rule.label)
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                menuId: menuId,
                id: id,
                info: error.errorTitle,
                message: error.errorDescription
            )
        }
    }

    func postRemoveWebMenuItem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let id = try context.requiredParameter("itemId")
        let nonceRequest = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard await AdminNonceStore.shared.consume(
            nonceRequest.nonce,
            sessionToken: context.sessionToken
        ) else { return Response(status: .badRequest) }
        do {
            try await runtime.interactor.delete(menuId: menuId, id: id)
            return AdminNotificationFlash.redirect(
                to: "/admin/web/menus/\(menuId)/items/",
                notification: .init(
                    title: "Removed",
                    message: "Item removed successfully."
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter
                .renderErrorPage(
                    menuId: menuId,
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription
                )
                .response(from: request, context: context)
        }
    }
}
