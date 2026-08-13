import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditContactFieldDefaultPresenter:
    AdminEditContactFieldPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderPage(
        field: AdminContactFieldRow,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit contact form field - Feather CMS",
            description: "Edit contact form field",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFieldEditView(
                state: .init(
                    field: field,
                    error: error,
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Contact", link: "/admin/contact/"),
                        .init(
                            label: "Fields",
                            link: "/admin/contact/fields/"
                        ), .init(label: "Edit", link: ""),
                    ])
                )
            )
        )
    }
}
