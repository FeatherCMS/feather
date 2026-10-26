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

extension Page.Search.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Page.Router.Routes

        func renderSearchPage(
            model: Page.Search.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse {
            let actions = AdminListActions(
                Set(
                    Page.Permissions.all()
                        .filter {
                            permissions.contains($0.rawValue)
                        }
                )
            )
            if let error {
                return try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "Manage web pages",
                    content: Page.Error.Page(
                        state: .init(
                            info: "Unable to load web pages.",
                            message: error,
                            breadcrumb: routes.listBreadcrumb
                        )
                    )
                )
            }
            guard actions.allows(Page.Permissions.list) else {
                return try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "Manage web pages",
                    content: Page.Error.Page(
                        state: .init(
                            info: "Forbidden",
                            message: "Your account cannot access web pages.",
                            breadcrumb: routes.listBreadcrumb
                        )
                    )
                )
            }
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage web pages",
                content: Page.Search.Table(
                    state: .init(
                        permissions: actions,
                        pages: model.items,
                        pageState: .init(
                            page: model.page,
                            pageSize: model.pageSize,
                            total: model.total
                        ),
                        search: search,
                        breadcrumb: routes.listBreadcrumb,
                        routes: routes
                    )
                )
            )
        }
    }
}
