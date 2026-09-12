import FeatherAdmin
import Hummingbird
import SystemAdminAPI
import WebComponents

struct AdminAddSystemPermissionDefaultPresenter:
    AdminAddSystemPermissionPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: SystemPermissionAddForm.State
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system permissions",
            content: SystemPermissionAddPage(
                state: .init(form: state, nonceToken: nonceToken)
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
            title: "Manage system permissions",
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }
}
