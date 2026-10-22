import BlogModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Author.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: BlogWebAdmin.Router.Routes

        func render(
            model: Author.List.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse {
            let canAccess = permissions.contains(
                Author.Permissions.list.rawValue
            )
            let canEdit = permissions.contains(
                Author.Permissions.update.rawValue
            )
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage blog authors",
                content: Author.List.Component(
                    state: .init(
                        canAccess: canAccess,
                        canEdit: canEdit,
                        canAdd: permissions.contains(
                            Author.Permissions.create.rawValue
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
                        breadcrumb: routes.authorsBreadcrumb,
                        routes: routes,
                        error: error
                    )
                )
            )
        }
    }
}
