import FeatherAdmin
import Foundation
import Hummingbird

struct AdminAddAccountInvitationDefaultPresenter:
    AdminAddAccountInvitationPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        form: AccountInvitationForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Add user invitation",
            description: "Add a user invitation in management",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AccountInvitationAdd(
                state: .init(
                    form: form,
                    breadcrumb: breadcrumb()
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

    func breadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Invitations", link: "/admin/account/invitations/"),
            .init(label: "Add", link: "/admin/account/invitations/add/"),
        ])
    }

    func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
