import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditContactFormSubmissionDefaultPresenter:
    AdminEditContactFormSubmissionPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderError(
        formId: String,
        id: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Contact form submission - Feather CMS",
            description: "Edit contact form submission",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormSubmissionDetailView(
                state: .init(
                    formId: formId,
                    item: .init(
                        id: id,
                        formId: formId,
                        status: "received",
                        createdAt: "",
                        email: nil,
                        values: [:]
                    ),
                    error: message,
                    isEdited: false,
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Contact", link: "/admin/contact/"),
                        .init(label: "Forms", link: "/admin/contact/forms/"),
                        .init(
                            label: "Submissions",
                            link: "/admin/contact/forms/\(formId)/submissions/"
                        ), .init(label: "Details", link: ""),
                    ])
                )
            )
        )
    }
}
