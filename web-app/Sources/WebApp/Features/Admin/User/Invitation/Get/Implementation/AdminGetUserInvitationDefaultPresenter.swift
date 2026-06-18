import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetUserInvitationDefaultPresenter:
    AdminGetUserInvitationPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        invitation: UserInvitationDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "User invitation details - Feather CMS",
            description: "Management user invitation details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserInvitationDetails(
                state: .init(
                    invitation: invitation,
                    breadcrumb: breadcrumb
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "User invitation details - Feather CMS",
            description: "Management user invitation details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserInvitationError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb
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
            .init(label: "Details", link: "/admin/user/invitations/\(id)/"),
        ])
    }
}
