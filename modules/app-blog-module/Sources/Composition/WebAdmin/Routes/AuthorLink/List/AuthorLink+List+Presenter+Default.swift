import BlogModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: AuthorLink.Router.Routes

        func render(
            authorID: String,
            model: AuthorLink.List.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage blog author links",
                content: AuthorLink.List.Component(
                    state: .init(
                        authorID: authorID,
                        canAccess: permissions.contains(
                            AuthorLink.Permissions.list.rawValue
                        ),
                        canAdd: permissions.contains(
                            AuthorLink.Permissions.create.rawValue
                        ),
                        items: model.items,
                        pageState: .init(
                            page: model.page,
                            pageSize: model.pageSize,
                            total: model.total
                        ),
                        search: search ?? "",
                        permissions: .init(
                            Set(permissions.map(PermissionKey.init))
                        ),
                        breadcrumb: routes.authorLinksBreadcrumb(
                            authorID
                        ),
                        routes: routes,
                        error: error
                    )
                )
            )
        }
    }
}
