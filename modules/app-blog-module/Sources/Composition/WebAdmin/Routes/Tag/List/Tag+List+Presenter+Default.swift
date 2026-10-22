import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Tag.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: BlogWebAdmin.Router.Routes

        func render(
            model: Tag.List.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse {
            let canAccess = permissions.contains(
                Tag.Permissions.list.rawValue
            )
            let canEdit = permissions.contains(
                Tag.Permissions.update.rawValue
            )
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage blog tags",
                content: Tag.List.Component(
                    state: .init(
                        canAccess: canAccess,
                        canEdit: canEdit,
                        canAdd: permissions.contains(
                            Tag.Permissions.create.rawValue
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
                        breadcrumb: routes.tagsBreadcrumb,
                        error: error,
                        routes: routes
                    )
                )
            )
        }
    }
}
