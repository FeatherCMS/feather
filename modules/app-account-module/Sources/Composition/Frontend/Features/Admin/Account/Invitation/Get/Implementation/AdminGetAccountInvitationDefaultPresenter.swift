import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct AdminGetAccountInvitationDefaultPresenter:
    AdminGetAccountInvitationPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        invitation: AccountInvitationDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "User invitation details",
            description: "Management user invitation details",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AccountInvitationDetails(
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
            title: "User invitation details",
            description: "Management user invitation details",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AccountInvitationError(
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
            .init(label: "Invitations", link: "/admin/account/invitations/"),
            .init(label: "Details", link: "/admin/account/invitations/\(id)/"),
        ])
    }
}
