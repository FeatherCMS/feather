import Foundation
import HTML
import Hummingbird
import WebStandards

struct AdminEditAuthAccessControlDefaultPresenter:
    AdminEditAuthAccessControlPresenter
{
    let request: Request
    let renderEngine: RenderingEngine

    func deniedPage(
        permissions: Set<String>,
        message: String
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "No permission - Feather CMS",
            description: "No permission",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: PermissionDeniedView(
                state: .init(
                    info: "No permission",
                    message: message,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func renderPage(
        state: AdminEditAuthAccessControlState,
        permissions: Set<String>,
        search: String
    ) -> HTMLResponse {
        let normalizedSearch = normalizedSearch(search)
        return renderEngine.renderAdminPage(
            request: request,
            title: "Access Control - Feather CMS",
            description: "Manage access control assignments",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthAccessControlMatrix(
                state: .init(
                    isEdited: state.isEdited,
                    error: state.error,
                    canEdit: state.canEdit,
                    roles: state.roles,
                    permissions: state.permissions,
                    selectedPairs: state.selectedPairs,
                    search: normalizedSearch,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    private func normalizedSearch(
        _ search: String?
    ) -> String {
        (search ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Auth", link: "/admin/auth/"),
                .init(
                    label: "Access Control",
                    link: "/admin/auth/access-control/"
                ),
            ]
        )
    }
}
