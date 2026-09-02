import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListContactFormEmailsDefaultPresenter:
    AdminListContactFormEmailsPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Contact form emails",
            description: "Manage contact form emails",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormEmails(
                id: item.id,
                mails: item.mails,
                canRemove: permissions.contains("contact:forms:update"),
                breadcrumb: breadcrumb(formId: item.id),
                error: error
            )
        )
    }

    private func breadcrumb(formId: String) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Contact", link: "/admin/contact/"),
            .init(label: "Forms", link: "/admin/contact/forms/"),
            .init(
                label: "Emails",
                link: "/admin/contact/forms/\(formId)/emails/"
            ),
        ])
    }
}
