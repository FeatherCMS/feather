import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminEditRedirectRuleDefaultPresenter: AdminEditRedirectRulePresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: RedirectRuleForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Edit redirect rule - Feather CMS",
            description: "Edit a management redirect rule",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: RedirectRuleEdit(
                state: .init(
                    id: id,
                    isEdited: isEdited,
                    form: state,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Edit redirect rule - Feather CMS",
            description: "Edit a management redirect rule",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: RedirectRuleError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Redirect", link: "/admin/redirect/"),
                .init(label: "Rules", link: "/admin/redirect/rules/"),
                .init(
                    label: "Edit",
                    link: "/admin/redirect/rules/\(id)/edit/"
                ),
            ]
        )
    }
}
