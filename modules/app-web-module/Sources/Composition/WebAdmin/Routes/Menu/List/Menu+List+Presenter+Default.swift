import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebDomain
import WebModule

extension WebModule.Menu.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine

        func renderListPage(
            model: WebModule.Menu.List.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse {
            let actions = AdminListActions(
                Set(
                    WebModule.Permissions.Menus.allPermissions()
                        .filter {
                            permissions.contains($0.rawValue)
                        }
                )
            )
            let canAccess = actions.allows(WebModule.Permissions.Menus.list)
            if let error {
                return try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "Manage menus",
                    content: MenuError(
                        state: .init(
                            info: "Unable to load web menus.",
                            message: error,
                            breadcrumb: MenuRoutes.listBreadcrumb
                        )
                    )
                )
            }
            guard canAccess else {
                return try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "Manage menus",
                    content: MenuError(
                        state: .init(
                            info: "Forbidden",
                            message: "Your account cannot access web menus.",
                            breadcrumb: MenuRoutes.listBreadcrumb
                        )
                    )
                )
            }
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage menus",
                content: MenuTable(
                    state: .init(
                        permissions: actions,
                        menus: model.items,
                        pageState: .init(
                            page: model.page,
                            pageSize: model.pageSize,
                            total: model.total
                        ),
                        search: search ?? "",
                        breadcrumb: MenuRoutes.listBreadcrumb
                    )
                )
            )
        }
    }
}
