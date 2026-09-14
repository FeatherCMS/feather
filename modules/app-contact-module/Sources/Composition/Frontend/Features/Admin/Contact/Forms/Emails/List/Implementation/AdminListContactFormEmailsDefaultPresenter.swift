import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormEmailsDefaultPresenter:
    AdminListContactFormEmailsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Contact form emails",
            description: "Manage contact form emails",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
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
        ])
    }
}
