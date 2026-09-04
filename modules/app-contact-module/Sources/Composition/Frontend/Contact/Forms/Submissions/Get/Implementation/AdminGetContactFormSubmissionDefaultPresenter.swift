import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminGetContactFormSubmissionDefaultPresenter:
    AdminGetContactFormSubmissionPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        formId: String,
        item: AdminContactFormSubmissionItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Contact form submission",
            description: "View contact form submission",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormSubmissionDetailView(
                state: .init(
                    formId: formId,
                    item: item,
                    error: error,
                    isEdited: request.hasQueryFlag("edited"),
                    breadcrumb: breadcrumb(formId: formId)
                )
            )
        )
    }

    private func breadcrumb(formId: String) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Contact", link: "/admin/contact/"),
            .init(label: "Forms", link: "/admin/contact/forms/"),
            .init(
                label: "Submissions",
                link: "/admin/contact/forms/\(formId)/submissions/"
            ), .init(label: "Details", link: ""),
        ])
    }
}
