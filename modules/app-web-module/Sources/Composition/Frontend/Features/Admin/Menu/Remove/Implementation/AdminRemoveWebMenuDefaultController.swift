import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveWebMenuDefaultController:
    AdminRemoveWebMenuController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveWebMenuInteractor,
            any AdminRemoveWebMenuPresenter
        >

    func getRemoveWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime((request, context))
        let id = try context.requiredID()
        do {
            let menu = try await runtime.interactor.get(id: id)
            return try await runtime.presenter.renderRemovePage(
                item: .init(id: id, label: menu.name)
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription
            )
        }
    }

    func postRemoveWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        let id = try context.requiredID()
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
            try await runtime.interactor.delete(id: id)
            return AdminNotificationFlash.redirect(
                to: "/admin/web/menus/",
                notification: .init(
                    title: "Removed",
                    message: "Menu removed successfully."
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter
                .renderErrorPage(
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription
                )
                .response(from: request, context: context)
        }
    }
}
