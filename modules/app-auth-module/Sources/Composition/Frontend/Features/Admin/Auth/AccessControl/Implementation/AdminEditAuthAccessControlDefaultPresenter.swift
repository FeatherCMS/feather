import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AdminEditAuthAccessControlDefaultPresenter:
    AdminEditAuthAccessControlPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func deniedPage(
        permissions: Set<String>,
        message: String
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "No permission",
            content: NewAdminStatusView(
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
        return try await renderEngine.renderNewAdminPage(
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
        (search ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

}
