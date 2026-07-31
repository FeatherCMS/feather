import Hummingbird

struct AdminListAuthCredentialAccountDefaultPresenter:
    AdminListAuthCredentialAccountPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        state: AuthCredentialAccountTable.State
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Credentials",
            description: "Select a user to manage credentials",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: state.permissions
            ),
            content: AuthCredentialAccountTable(state: state)
        )
    }

    func renderError(
        error: OpenAPIRepositoryError
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Credentials",
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
                    ])
                )
            )
        )
    }
}
