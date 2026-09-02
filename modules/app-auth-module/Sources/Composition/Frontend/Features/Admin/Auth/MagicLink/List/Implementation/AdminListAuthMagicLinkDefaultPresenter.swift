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
import WebStandards

struct AdminListAuthMagicLinkDefaultPresenter:
    AdminListAuthMagicLinkPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        state: AuthMagicLinkTable.State
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Manage user magic links - Feather CMS",
            description: "Management user magic link list",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: state.permissions
            ),
            content: AuthMagicLinkTable(state: state)
        )
    }

    func renderError(
        error: OpenAPIRepositoryError
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Manage user magic links - Feather CMS",
            description: "Management user magic link list",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: []
            ),
            content: AuthMagicLinkError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func renderRemoveConfirmation(
        selectedIds: [String],
        page: Int,
        search: String?,
        userID: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove selected magic links",
            description: "Confirm remove",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListRemoveConfirmation(
                state: .init(
                    breadcrumb: breadcrumb(),
                    title: "Remove selected magic links",
                    message:
                        "Are you sure you want to remove these selected magic links? This action cannot be undone.",
                    action: "/admin/auth/magic-links/remove/",
                    cancelLink: ListRemoveRedirect.location(
                        path: "/admin/auth/magic-links/",
                        page: page,
                        search: search,
                        queryItems: userID.map { [("userId", $0)] } ?? [],
                        title: nil,
                        message: nil
                    ),
                    selectedIds: selectedIds,
                    hiddenFields: [
                        .init(name: "page", value: "\(page)")
                    ]
                        + (search.map {
                            [.init(name: "search", value: $0)]
                        } ?? [])
                        + (userID.map {
                            [.init(name: "userId", value: $0)]
                        } ?? [])
                )
            )
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Magic links", link: "/admin/auth/magic-links/"),
        ])
    }
}
