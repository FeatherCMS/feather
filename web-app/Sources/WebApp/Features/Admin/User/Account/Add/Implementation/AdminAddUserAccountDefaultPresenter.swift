import HTML
import Hummingbird

struct AdminAddUserAccountDefaultPresenter: AdminAddUserAccountPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        form: UserAccountForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Add account",
            description: "Add user account",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserAccountAdd(
                state: .init(
                    form: form,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func formState(
        email: String = ""
    ) -> UserAccountForm.State {
        .init(
            email: .init(
                key: "email",
                label: "Email address",
                isRequired: true,
                value: email,
                error: nil
            ),
            password: .init(
                key: "password",
                label: "Password",
                isRequired: true,
                value: "",
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
                .init(label: "Accounts", link: "/admin/user/accounts/"),
                .init(label: "Add", link: "/admin/user/accounts/add/"),
            ]
        )
    }

    func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
