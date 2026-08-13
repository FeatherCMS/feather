import FeatherAdmin
import HTML
import Hummingbird

struct AdminAddUserIdentityDefaultPresenter: AdminAddUserIdentityPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        form: UserIdentityForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Add identity",
            description: "Add user identity",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserIdentityAdd(
                state: .init(
                    form: form,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func formState(
        status: String = "invited"
    ) -> UserIdentityForm.State {
        .init(
            status: .init(
                key: "status",
                label: "Status",
                isRequired: true,
                value: status,
                error: nil
            ),
            roleOptions: [],
            roleIdsError: nil,
            error: nil,
            success: nil
        )
    }

    func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "User", link: "/admin/user/"),
                .init(label: "Identities", link: "/admin/user/identities/"),
                .init(label: "Add", link: "/admin/user/identities/add/"),
            ]
        )
    }

    func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
