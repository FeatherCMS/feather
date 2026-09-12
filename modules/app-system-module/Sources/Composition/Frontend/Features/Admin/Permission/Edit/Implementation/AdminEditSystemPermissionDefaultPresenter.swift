import FeatherAdmin
import Hummingbird
import SystemAdminAPI
import WebComponents

struct AdminEditSystemPermissionDefaultPresenter:
    AdminEditSystemPermissionPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: SystemPermissionEditForm.State,
        isEdited: Bool
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system permissions",
            content: SystemPermissionEditPage(
                state: .init(
                    id: id,
                    isEdited: isEdited,
                    form: state,
                    nonceToken: nonceToken
                )
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
