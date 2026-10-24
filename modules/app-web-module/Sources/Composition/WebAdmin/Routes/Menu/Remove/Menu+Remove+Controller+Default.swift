import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Remove.Controller {
    struct Default: Interface {
        let routes: WebModule.Menu.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any WebModule.Menu.Remove.Interactor.Interface,
                any WebModule.Menu.Remove.Presenter.Interface
            >

        func getRemoveMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            guard
                context.isCurrentUserAllowed(
                    to: Menu.Permissions.delete
                )
            else {
                return HTMLResponse(content: "", status: .forbidden)
            }
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

        func postRemoveMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            guard
                context.isCurrentUserAllowed(
                    to: Menu.Permissions.delete
                )
            else { return Response(status: .forbidden) }
            let routeMenuID = context.parameters.get("id")
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
            if let routeMenuID, ids != [routeMenuID] {
                return Response(status: .badRequest)
            }
            let location = AdminLocation.url(
                path: routes.list.path,
                page: nonceRequest.input.normalizedPage,
                search: nonceRequest.input.normalizedSearch
            )
            guard !ids.isEmpty else {
                return Response(
                    status: .seeOther,
                    headers: [.location: location]
                )
            }
            do {
                try await runtime.interactor.delete(ids: ids)
                return AdminNotificationFlash.redirect(
                    to: location,
                    notification: .init(
                        title: "Removed",
                        message: ids.count == 1
                            ? "Menu removed successfully."
                            : "Menus removed successfully."
                    )
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter
                    .renderErrorPage(
                        id: ids[0],
                        info: error.errorTitle,
                        message: error.errorDescription
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
