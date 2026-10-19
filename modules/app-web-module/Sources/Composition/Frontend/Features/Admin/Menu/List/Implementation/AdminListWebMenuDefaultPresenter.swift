import FeatherAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct AdminListWebMenuDefaultPresenter:
    AdminListWebMenuPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListWebMenuModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let actions = AdminListActions(
            Set(
                WebPermissions.Menus.allPermissions()
                    .filter {
                        permissions.contains($0.rawValue)
                    }
            )
        )
        let canAccess = actions.allows(WebPermissions.Menus.list)
        if let error {
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage menus",
                content: WebMenuError(
                    state: .init(
                        info: "Unable to load web menus.",
                        message: error,
                        breadcrumb: WebMenuRoutes.listBreadcrumb
                    )
                )
            )
        }
        guard canAccess else {
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage menus",
                content: WebMenuError(
                    state: .init(
                        info: "Forbidden",
                        message: "Your account cannot access web menus.",
                        breadcrumb: WebMenuRoutes.listBreadcrumb
                    )
                )
            )
        }
        return try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Manage menus",
            content: WebMenuTable(
                state: .init(
                    permissions: actions,
                    menus: model.items,
                    pageState: .init(
                        page: model.page,
                        pageSize: model.pageSize,
                        total: model.total
                    ),
                    search: search ?? "",
                    breadcrumb: WebMenuRoutes.listBreadcrumb
                )
            )
        )
    }
}
