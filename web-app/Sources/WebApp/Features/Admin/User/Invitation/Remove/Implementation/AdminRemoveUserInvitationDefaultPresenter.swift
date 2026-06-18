import Foundation
import Hummingbird

struct AdminRemoveUserInvitationDefaultPresenter:
    AdminRemoveUserInvitationPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderRemovePage(
        id: String,
        email: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Manage user invitations - Feather CMS",
            description: "Management user invitation list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserInvitationConfirmation(
                state: .init(
                    id: id,
                    email: email,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove user invitation - Feather CMS",
            description: "Remove confirmation for a management user invitation",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserInvitationError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Invitations", link: "/admin/user/invitations/"),
            .init(
                label: "Remove",
                link: "/admin/user/invitations/\(id)/remove/"
            ),
        ])
    }
}
