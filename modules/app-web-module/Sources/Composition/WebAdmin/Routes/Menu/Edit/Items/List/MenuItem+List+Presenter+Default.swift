import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModule

extension MenuItem.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: MenuItem.Router.Routes

        func renderListPage(
            menuId: String,
            model: MenuItem.List.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse {
            let actions = AdminListActions(
                Set(
                    WebModule.Permissions.MenuItems.allPermissions()
                        .filter {
                            permissions.contains($0.rawValue)
                        }
                )
            )
            if let error {
                return try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "Edit menu",
                    content: MenuItemError(
                        state: .init(
                            info: "Unable to load web menu items.",
                            message: error,
                            breadcrumb: routes.itemBreadcrumb(menuId)
                        )
                    )
                )
            }
            guard actions.allows(WebModule.Permissions.MenuItems.list) else {
                return try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "Edit menu",
                    content: MenuItemError(
                        state: .init(
                            info: "Forbidden",
                            message:
                                "Your account cannot access web menu items.",
                            breadcrumb: routes.itemBreadcrumb(menuId)
                        )
                    )
                )
            }
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit menu",
                content: MenuItemTable(
                    state: .init(
                        menuId: menuId,
                        permissions: actions,
                        items: model.items,
                        pageState: .init(
                            page: model.page,
                            pageSize: model.pageSize,
                            total: model.total
                        ),
                        search: search,
                        breadcrumb: routes.itemBreadcrumb(menuId),
                        routes: routes
                    )
                )
            )
        }
    }
}
