import Hummingbird

struct AdminGetRedirectNotFoundDefaultPresenter:
    AdminGetRedirectNotFoundPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func render(
        model: AdminGetRedirectNotFoundModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: model.title,
            description: model.description,
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: RedirectNotFoundView(model: model)
        )
    }

    func renderDenied(
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "404s",
            description: "404 trends and missing routes.",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: PermissionDeniedView(
                state: .init(
                    info: "Your account cannot access 404 analytics.",
                    message: "Ask an administrator for analytics permissions.",
                    breadcrumb: redirectNotFoundBreadcrumb
                )
            )
        )
    }

    func renderError(
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "404s",
            description: "404 trends and missing routes.",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: PermissionDeniedView(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: redirectNotFoundBreadcrumb
                )
            )
        )
    }

    private var redirectNotFoundBreadcrumb: AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Redirect", link: "/admin/redirect/"),
                .init(label: "404s", link: "/admin/redirect/404s/"),
            ]
        )
    }
}
