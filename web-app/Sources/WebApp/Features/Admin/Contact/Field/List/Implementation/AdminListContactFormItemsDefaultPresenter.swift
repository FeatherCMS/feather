import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListContactFormItemsDefaultPresenter:
    AdminListContactFormItemsPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderList(
        formId: String,
        items: [AdminContactFormItemRow],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Contact form fields - Feather CMS",
            description: "Manage contact form fields",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormItemsTable(
                state: .init(
                    formId: formId,
                    items: items,
                    search: search,
                    error: error,
                    isEdited: request.hasQueryFlag("edited"),
                    isRemoved: request.hasQueryFlag("removed"),
                    canRemove: permissions.contains(
                        "contact:form-items:delete"
                    ),
                    breadcrumb: breadcrumb(formId: formId)
                )
            )
        )
    }
    private func breadcrumb(formId: String) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Contact", link: "/admin/contact/"),
            .init(
                label: "Fields",
                link: formId == "__global_contact_fields__"
                    ? "/admin/contact/fields/"
                    : "/admin/contact/forms/\(formId)/items/"
            ),
        ])
    }
}
