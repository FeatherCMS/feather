import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormEmailDefaultPresenter:
    AdminEditContactFormEmailPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        formId: String,
        mail: AdminContactFormEmail,
        availableFields: [AdminContactFormFieldOption],
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Edit contact form email",
            description: "Edit contact form email",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SubmissionMailEdit(
                formId: formId,
                mail: mail,
                availableFields: availableFields,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Contact", link: "/admin/contact/"),
                    .init(label: "Forms", link: "/admin/contact/forms/"),
                    .init(
                        label: "Emails",
                        link: "/admin/contact/forms/\(formId)/emails/"
                    ),
                    .init(
                        label: "Edit",
                        link:
                            "/admin/contact/forms/\(formId)/emails/\(mail.id)/edit/"
                    ),
                ]),
                error: error
            )
        )
    }
}
