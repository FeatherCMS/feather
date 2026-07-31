import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListContactFormsDefaultPresenter: AdminListContactFormsPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderList(
        items: [AdminContactFormDetailsItem],
        search: String,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        isPicker: Bool,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Contact forms - Feather CMS",
            description: "Manage contact forms",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormTable(
                state: .init(
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    items: items,
                    search: search,
                    canRemove: permissions.contains("contact:forms:delete"),
                    isPicker: isPicker,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Contact", link: "/admin/contact/"),
            .init(label: "Forms", link: "/admin/contact/forms/"),
        ])
    }
}
