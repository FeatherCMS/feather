import AuthContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct AdminListAuthSessionDefaultPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func render(
        model: AdminListAuthSessionModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Sessions",
            description: "List user sessions",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminListAuthSessionView(
                state: .init(
                    identityID: model.identityID,
                    items: model.items,
                    canRemove: permissions.contains(
                        AuthPermissions.Sessions.delete.rawValue
                    )
                )
            )
        )
    }

    func renderError(
        error: OpenAPIRepositoryError,
        identityID: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: error.errorTitle,
            description: error.errorDescription,
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: PermissionDeniedView(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: .init(
                        links: [
                            .init(label: "Admin", link: "/admin/"),
                            .init(label: "User", link: "/admin/user/"),
                            .init(
                                label: "Identity",
                                link: "/admin/user/identities/\(identityID)/"
                            ),
                            .init(
                                label: "Sessions",
                                link: request.uri.path
                            ),
                        ]
                    )
                )
            )
        )
    }
}
