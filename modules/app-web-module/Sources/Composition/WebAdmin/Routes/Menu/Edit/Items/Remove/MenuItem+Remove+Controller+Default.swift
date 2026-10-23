import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension MenuItem.Remove.Controller {
    struct Default: Interface {
        let routes: MenuItem.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any MenuItem.Remove.Interactor.Interface,
                any MenuItem.Remove.Presenter.Interface
            >

        func getRemoveMenuItem(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let menuId = try context.requiredID()
            let id = try context.requiredParameter("itemId")
            let origin = routes.removeOrigin(request.queryString("origin"))
            guard
                context.isCurrentUserAllowed(
                    to: WebModule.Permissions.MenuItems.delete
                )
            else {
                return HTMLResponse(content: "", status: .forbidden)
            }
            do {
                let item = try await runtime.interactor.get(
                    menuId: menuId,
                    id: id
                )
                return try await runtime.presenter.renderRemovePage(
                    menuId: menuId,
                    item: .init(id: id, label: item.label),
                    origin: origin
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter.renderErrorPage(
                    menuId: menuId,
                    info: error.errorTitle,
                    message: error.errorDescription
                )
            }
        }

        func postRemoveMenuItem(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let menuId = try context.requiredID()
            let itemId = context.parameters.get("itemId")
            let origin = routes.removeOrigin(request.queryString("origin"))
            guard
                context.isCurrentUserAllowed(
                    to: WebModule.Permissions.MenuItems.delete
                )
            else { return Response(status: .forbidden) }
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
            if let itemId, ids != [itemId] {
                return Response(status: .badRequest)
            }
            let locationPath: String
            if let itemId {
                switch origin {
                case .list:
                    locationPath = routes.itemsPath(menuId)
                case .edit:
                    locationPath = routes.itemEditPath(
                        menuID: menuId,
                        itemID: itemId
                    )
                case .view:
                    locationPath = routes.itemDetailsPath(
                        menuID: menuId,
                        itemID: itemId
                    )
                }
            }
            else {
                locationPath = routes.itemsPath(menuId)
            }
            let location: String
            if itemId == nil {
                location = AdminLocation.url(
                    path: locationPath,
                    page: nonceRequest.input.normalizedPage,
                    search: nonceRequest.input.normalizedSearch
                )
            }
            else {
                switch origin {
                case .list:
                    location = AdminLocation.url(
                        path: locationPath,
                        page: nonceRequest.input.normalizedPage,
                        search: nonceRequest.input.normalizedSearch
                    )
                case .edit, .view:
                    location = locationPath
                }
            }
            guard !ids.isEmpty else {
                return Response(
                    status: .seeOther,
                    headers: [.location: location]
                )
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
                        info: error.errorTitle,
                        message: error.errorDescription
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
