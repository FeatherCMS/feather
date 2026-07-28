import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListContactFieldsDefaultPresenter:
    AdminListContactFieldsPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderList(
        fields: [AdminContactFieldRow],
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
            content: ContactFieldsTable(
                state: .init(
                    fields: fields,
                    search: search,
                    error: error,
                    isEdited: request.hasQueryFlag("edited"),
                    isRemoved: request.hasQueryFlag("removed"),
                    canRemove: permissions.contains(
                        "contact:form-items:delete"
                    ),
                    breadcrumb: breadcrumb
                )
            )
        )
    }
    private let breadcrumb = AdminBreadcrumb.State(links: [
        .init(label: "Admin", link: "/admin/"),
        .init(label: "Contact", link: "/admin/contact/"),
        .init(label: "Fields", link: "/admin/contact/fields/"),
    ])
}
