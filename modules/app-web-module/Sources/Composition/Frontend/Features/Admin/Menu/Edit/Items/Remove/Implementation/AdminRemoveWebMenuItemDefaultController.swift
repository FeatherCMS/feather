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
        let origin = WebMenuItemRoutes.removeOrigin(
            request.queryString("origin")
        )
        do {
            let rule = try await runtime.interactor.get(menuId: menuId, id: id)
            return try await runtime.presenter.renderRemovePage(
                menuId: menuId,
                item: .init(id: id, label: rule.label),
                origin: origin
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                menuId: menuId,
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                origin: origin
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
        let origin = WebMenuItemRoutes.removeOrigin(
            request.queryString("origin")
        )
        let nonceRequest = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        do {
            try await runtime.interactor.delete(menuId: menuId, id: id)
            return AdminNotificationFlash.redirect(
                to: WebMenuItemRoutes.list(RouterPath(menuId)).description,
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
                    message: error.errorDescription,
                    origin: origin
                )
                .response(from: request, context: context)
        }
    }
}
