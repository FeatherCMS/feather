import FeatherAdmin
import HTML
import Hummingbird
import SGML

struct AdminGetUserIdentityDefaultPresenter: AdminGetUserIdentityPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderPage(
        model: AdminGetUserIdentityModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "User identity details - Feather CMS",
            description: "Management user identity details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserIdentityDetails(
                state: .init(
                    identity: model,
                    breadcrumb: breadcrumb(id: model.id),
                    permissions: permissions
                )
            )
        )
    }

    func errorPage(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "User identity details - Feather CMS",
            description: "Management user identity details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserIdentityError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Identities", link: "/admin/user/identities/"),
            .init(label: "Details", link: "/admin/user/identities/\(id)/"),
        ])
    }
}
