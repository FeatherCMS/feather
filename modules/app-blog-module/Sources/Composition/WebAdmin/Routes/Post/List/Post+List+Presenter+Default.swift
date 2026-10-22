import BlogModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebModuleWebAdmin

extension Post.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Post.Router.Routes

        func render(
            model: Post.List.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage blog posts",
                content: Post.List.Component(
                    state: .init(
                        canAccess: permissions.contains(
                            Post.Permissions.list.rawValue
                        ),
                        canEdit: permissions.contains(
                            Post.Permissions.update.rawValue
                        ),
                        canAdd: permissions.contains(
                            Post.Permissions.create.rawValue
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
                        breadcrumb: routes.postsBreadcrumb,
                        routes: routes,
                        error: error
                    )
                )
            )
        }
    }
}
