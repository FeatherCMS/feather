import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

struct AdminRemoveMenuItemDefaultController:
    AdminRemoveMenuItemController
{
    let routes: WebModule.Menu.Router.Routes
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminRemoveMenuItemInteractor,
            any AdminRemoveMenuItemPresenter
        >

    func postRemoveMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let origin = routes.removeOrigin(request.queryString("origin"))
        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        let ids = nonceRequest.input.normalizedIds
        let location = AdminLocation.url(
            path: routes.itemsPath(menuId),
            page: nonceRequest.input.normalizedPage,
            search: nonceRequest.input.normalizedSearch
        )
        guard !ids.isEmpty else {
            return Response(status: .seeOther, headers: [.location: location])
        }
        do {
            try await runtime.interactor.delete(menuId: menuId, ids: ids)
            return AdminNotificationFlash.redirect(
                to: location,
                notification: .init(
                    title: "Removed",
                    message: ids.count == 1
                        ? "Item removed successfully."
                        : "Items removed successfully."
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter
                .renderErrorPage(
                    menuId: menuId,
                    id: ids[0],
                    info: error.errorTitle,
                    message: error.errorDescription,
                    origin: origin
                )
                .response(from: request, context: context)
        }
    }
}
