import Hummingbird

struct AdminListAuthCredentialDefaultPresenter: AdminListAuthCredentialPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        state: AuthCredentialTable.State
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "User credentials",
            description: "Manage user credentials",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: state.permissions
            ),
            content: AuthCredentialTable(state: state)
        )
    }

    func renderError(
        error: OpenAPIRepositoryError,
        accountID: String
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "User credentials",
            description: "Credentials error",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: []
            ),
            content: AuthCredentialError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Auth", link: "/admin/auth/"),
                        .init(
                            label: "Credentials",
                            link: "/admin/auth/credentials/"
                        ),
                        .init(
                            label: "User",
                            link: "/admin/auth/credentials/\(accountID)/"
                        ),
                    ])
                )
            )
        )
    }
}
