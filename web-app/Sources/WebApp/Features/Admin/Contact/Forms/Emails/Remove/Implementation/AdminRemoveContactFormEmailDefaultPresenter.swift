import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminRemoveContactFormEmailDefaultPresenter:
    AdminRemoveContactFormEmailPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        formId: String,
        mail: AdminContactFormEmail,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove contact form email - Feather CMS",
            description: "Remove contact form email",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormMailRemove(
                formId: formId,
                mail: mail,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Contact", link: "/admin/contact/"),
                    .init(label: "Forms", link: "/admin/contact/forms/"),
                    .init(
                        label: "Emails",
                        link: "/admin/contact/forms/\(formId)/emails/"
                    ),
                    .init(
                        label: "Remove",
                        link:
                            "/admin/contact/forms/\(formId)/emails/remove/?selectedIds[]=\(mail.id)"
                    ),
                ])
            )
        )
    }

    func renderBulkConfirmation(
        formId: String,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove contact form emails - Feather CMS",
            description: "Remove contact form emails",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(state: .init(
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Contact", link: "/admin/contact/"),
                    .init(label: "Forms", link: "/admin/contact/forms/"),
                    .init(label: "Emails", link: "/admin/contact/forms/\(formId)/emails/"),
                    .init(label: "Remove", link: "")
                ]),
                title: "Remove contact form emails",
                message: "Are you sure you want to remove the selected contact form emails? This action cannot be undone.",
                action: "/admin/contact/forms/\(formId)/emails/remove/",
                cancelLink: "/admin/contact/forms/\(formId)/emails/",
                selectedIds: selectedIds
            ))
        )
    }
}
