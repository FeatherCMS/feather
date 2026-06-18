import Foundation
import Hummingbird

struct AdminGetAuthMagicLinkDefaultPresenter: AdminGetAuthMagicLinkPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Magic links", link: "/admin/auth/magic-links/"),
            .init(label: "Details", link: "/admin/auth/magic-links/\(id)/"),
        ])
    }

    func renderPage(
        link: AuthMagicLinkDetailsModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "User magic link details - Feather CMS",
            description: "Management user magic link details",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthMagicLinkDetails(
                state: .init(
                    link: link,
                    breadcrumb: breadcrumb(id: link.id)
                )
            )
        )
    }

    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "User magic link details - Feather CMS",
            description: "Management user magic link details",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthMagicLinkError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }
}
