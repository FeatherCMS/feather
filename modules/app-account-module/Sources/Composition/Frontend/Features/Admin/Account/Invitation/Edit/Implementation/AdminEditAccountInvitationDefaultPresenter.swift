import FeatherAdmin
import Foundation
import Hummingbird

struct AdminEditAccountInvitationDefaultPresenter:
    AdminEditAccountInvitationPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: AccountInvitationForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit user invitation",
            description: "Edit a management user invitation",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AccountInvitationEdit(
                state: .init(
                    id: id,
                    isEdited: isEdited,
                    form: state,
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
            title: "Edit user invitation",
            description: "Edit a management user invitation",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AccountInvitationError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func formState(
        email: String = "",
        roleIDs: [String] = [],
        roleOptions: [AccountInvitationForm.RoleOptionState] = []
    ) -> AccountInvitationForm.State {
        .init(
            email: .init(
                key: "email",
                label: "Email address",
                value: email,
                error: nil
            ),
            roleIds: .init(
                key: "roleIds",
                label: "Role IDs (comma-separated)",
                value: roleIDs.joined(separator: ", "),
                error: nil
            ),
            roleOptions: roleOptions,
            error: nil,
            success: nil
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Invitations", link: "/admin/account/invitations/"),
            .init(
                label: "Edit",
                link: "/admin/account/invitations/\(id)/edit/"
            ),
        ])
    }

    func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
