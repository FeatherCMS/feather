import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminAddSystemVariableDefaultPresenter: AdminAddSystemVariablePresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: SystemVariableForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add system variable - Feather CMS",
            description: "Add a system variable in management",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemVariableAdd(
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
                .init(label: "System", link: "/admin/system/"),
                .init(label: "Variables", link: "/admin/system/variables/"),
                .init(label: "Add", link: "/admin/system/variables/add/"),
            ]
        )
    }
}
