import FeatherAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct AdminListWebMenuItemDefaultPresenter:
    AdminListWebMenuItemPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        menuId: String,
        model: AdminListWebMenuItemModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let actions = AdminListActions(
            Set(
                WebPermissions.MenuItems.allPermissions()
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
                content: WebMenuItemError(
                    state: .init(
                        info: "Unable to load web menu items.",
                        message: error,
                        breadcrumb: WebMenuRoutes.breadcrumb
                    )
                )
            )
        }
        guard actions.allows(WebPermissions.MenuItems.list) else {
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit menu",
                content: WebMenuItemError(
                    state: .init(
                        info: "Forbidden",
                        message: "Your account cannot access web menu items.",
                        breadcrumb: WebMenuRoutes.breadcrumb
                    )
                )
            )
        }
        return try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Edit menu",
            content: WebMenuItemTable(
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
                    breadcrumb: WebMenuRoutes.breadcrumb
                )
            )
        )
    }
}
