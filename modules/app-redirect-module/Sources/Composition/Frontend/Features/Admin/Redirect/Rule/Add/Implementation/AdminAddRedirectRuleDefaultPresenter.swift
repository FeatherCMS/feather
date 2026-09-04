import FeatherAdmin
import Foundation
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct AdminAddRedirectRuleDefaultPresenter: AdminAddRedirectRulePresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: RedirectRuleForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add redirect rule",
            description: "Add a redirect rule in management",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: RedirectRuleAdd(
                state: .init(
                    form: state,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Redirect", link: "/admin/redirect/"),
                .init(label: "Rules", link: "/admin/redirect/rules/"),
                .init(label: "Add", link: "/admin/redirect/rules/add/"),
            ]
        )
    }
}
