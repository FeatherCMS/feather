import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditContactFormFieldDefaultPresenter:
    AdminEditContactFormFieldPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderPage(
        formId: String,
        field: AdminContactFormFieldRow,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit contact form field",
            description: "Edit contact form field",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormFieldEditView(
                state: .init(
                    formId: formId,
                    field: field,
                    error: error,
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Contact", link: "/admin/contact/"),
                        .init(
                            label: "Fields",
                            link: "/admin/contact/forms/\(formId)/fields/"
                        ), .init(label: "Edit", link: ""),
                    ])
                )
            )
        )
    }
}
