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
        let routes: WebModule.Menu.Router.Routes

        func renderListPage(
            model: WebModule.Menu.List.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse {
            let actions = AdminListActions(
                Set(
                    Menu.Permissions.all()
                        .filter {
                            permissions.contains($0.rawValue)
                        }
                )
            )
            let canAccess = actions.allows(Menu.Permissions.list)
            if let error {
                return try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "Manage menus",
                    content: Menu.Error.Page(
                        state: .init(
                            info: "Unable to load web menus.",
                            message: error,
                            breadcrumb: routes.listBreadcrumb
                        )
                    )
                )
            }
            guard canAccess else {
                return try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "Manage menus",
                    content: Menu.Error.Page(
                        state: .init(
                            info: "Forbidden",
                            message: "Your account cannot access web menus.",
                            breadcrumb: routes.listBreadcrumb
                        )
                    )
                )
            }
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage menus",
                content: WebModule.Menu.List.Page(
                    state: .init(
                        permissions: actions,
                        menus: model.items,
                        pageState: .init(
                            page: model.page,
                            pageSize: model.pageSize,
                            total: model.total
                        ),
                        search: search ?? "",
                        breadcrumb: routes.listBreadcrumb,
                        routes: routes
                    )
                )
            )
        }
    }
}
