import Hummingbird

struct AdminRemoveAuthCredentialDefaultPresenter: AdminRemoveAuthCredentialPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(model: AuthCredentialDetailsModel, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove credential",
            description: "Remove a user credential",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions),
            content: AuthCredentialConfirmation(
                state: .init(
                    id: model.id,
                    accountID: model.accountID,
                    email: model.email,
                    breadcrumb: breadcrumb(model: model)
                )
            )
        )
    }

    func renderError(id: String, error: OpenAPIRepositoryError, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove credential",
            description: "Credentials error",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions),
            content: AuthCredentialError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Auth", link: "/admin/auth/"),
                        .init(label: "Credentials", link: "/admin/auth/credentials/"),
                        .init(label: "Remove", link: "/admin/auth/credentials/\(id)/remove/"),
                    ])
                )
            )
        )
    }

    private func breadcrumb(model: AuthCredentialDetailsModel) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Credentials", link: "/admin/auth/credentials/"),
            .init(label: "User", link: "/admin/auth/credentials/\(model.accountID)/"),
            .init(label: "Remove", link: "/admin/auth/credentials/\(model.id)/remove/"),
        ])
    }
}
