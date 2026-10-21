import AuthAdminAPI
import CSS
import FeatherModuleKit
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

struct AdminEditAuthAccessControlDefaultPresenter:
    AdminEditAuthAccessControlPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func deniedPage(
        permissions: Set<String>,
        message: String
    ) async throws -> HTMLResponse {
        try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "No permission",
            content: AdminStatusView(
                state: .init(
                    title: "No permission",
                    message: message
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    func renderPage(
        state: AdminEditAuthAccessControlState,
        permissions: Set<String>,
        search: String
    ) async throws -> HTMLResponse {
        let normalizedSearch = normalizedSearch(search)
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Access Control",
            content: AuthAccessControlMatrix(
                state: .init(
                    isEdited: state.isEdited,
                    error: state.error,
                    canEdit: state.canEdit,
                    roles: state.roles,
                    permissions: state.permissions,
                    selectedPairs: state.selectedPairs,
                    search: normalizedSearch,
                    breadcrumb: AuthAccessControlRoutes.breadcrumb,
                    nonceToken: nonceToken
                )
            )
        )
    }

    private func normalizedSearch(
        _ search: String?
    ) -> String {
        (search ?? "").whitespaceTrimmed
    }

}
