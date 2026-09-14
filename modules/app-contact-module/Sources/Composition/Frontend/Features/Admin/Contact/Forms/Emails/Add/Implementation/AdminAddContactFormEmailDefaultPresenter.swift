import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactFormEmailDefaultPresenter:
    AdminAddContactFormEmailPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        formId: String,
        availableFields: [AdminContactFormFieldOption],
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add contact form email",
            description: "Add contact form email",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SubmissionMailAdd(
                formId: formId,
                mail: .init(
                    id: "",
                    mailFrom: "",
                    mailTo: "",
                    subject: "",
                    additionalHeaders: "",
                    messageBody: ""
                ),
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
                        label: "Add",
                        link: "/admin/contact/forms/\(formId)/emails/add/"
                    ),
                ]),
                error: error
            )
        )
    }
}
