import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SystemContracts
import WebBuilders
import WebComponents

struct AdminListSystemPermissionDefaultPresenter:
    AdminListSystemPermissionPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderListPage(
        model: AdminListSystemPermissionModel,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Permissions",
            content: SystemPermissionTable(
                state: .init(
                    permissions: permissions,
                    permissionsList: model.items,
                    pageState: .init(
                        page: model.page,
                        pageSize: model.pageSize,
                        total: model.total
                    ),
                    search: search
                )
            )
        )
    }

    func renderErrorPage(
        title: String,
        message: String
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Permissions",
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

}
