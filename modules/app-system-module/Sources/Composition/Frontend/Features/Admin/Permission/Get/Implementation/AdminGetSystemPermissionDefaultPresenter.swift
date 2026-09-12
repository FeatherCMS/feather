import FeatherAdmin
import Hummingbird
import SystemAdminAPI
import WebComponents

struct AdminGetSystemPermissionDefaultPresenter:
    AdminGetSystemPermissionPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        permission: SystemPermissionDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "System permission details",
            content: SystemPermissionDetailsView(
                state: .init(permission: permission, permissions: permissions)
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "System permission details",
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }
}
