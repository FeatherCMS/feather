import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListContactFormSubmissionsDefaultPresenter:
    AdminListContactFormSubmissionsPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderList(
        formId: String,
        items: [AdminContactFormSubmissionItem],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Contact form submissions - Feather CMS",
            description: "Track contact form submissions",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormSubmissionsTable(
                state: .init(
                    formId: formId,
                    items: items,
                    search: search,
                    error: error,
                    breadcrumb: breadcrumb(formId: formId),
                    canRemove: permissions.contains(
                        "contact:form-submissions:delete"
                    )
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
            ),
        ])
    }
}
