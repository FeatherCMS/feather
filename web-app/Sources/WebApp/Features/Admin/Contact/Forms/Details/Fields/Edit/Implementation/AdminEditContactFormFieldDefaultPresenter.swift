import HTML
import Hummingbird
import SGML
import WebStandards

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
            title: "Edit contact form field - Feather CMS",
            description: "Edit contact form field",
            imagePath: "images/puppy.png",
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
                            link: "/admin/contact/forms/\(formId)/items/"
                        ), .init(label: "Edit", link: ""),
                    ])
                )
            )
        )
    }
}
