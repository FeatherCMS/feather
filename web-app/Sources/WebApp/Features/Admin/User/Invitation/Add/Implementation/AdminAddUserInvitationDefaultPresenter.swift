import Foundation
import Hummingbird

struct AdminAddUserInvitationDefaultPresenter: AdminAddUserInvitationPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        form: UserInvitationForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Add user invitation - Feather CMS",
            description: "Add a user invitation in management",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserInvitationAdd(
                state: .init(
                    form: form,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func formState(
        email: String = ""
    ) -> UserInvitationForm.State {
        .init(
            email: .init(
                key: "email",
                label: "Email address",
                value: email,
                error: nil
            ),
            error: nil,
            success: nil
        )
    }

    func breadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Invitations", link: "/admin/user/invitations/"),
            .init(label: "Add", link: "/admin/user/invitations/add/"),
        ])
    }

    func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
