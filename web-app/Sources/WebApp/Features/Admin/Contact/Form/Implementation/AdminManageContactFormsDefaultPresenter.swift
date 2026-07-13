import Hummingbird

struct AdminManageContactFormsDefaultPresenter: AdminManageContactFormsPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderList(items: [AdminManageContactFormItem], isAdded: Bool, isEdited: Bool, isRemoved: Bool, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Contact forms - Feather CMS", description: "Manage contact forms", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormTable(state: .init(isAdded: isAdded, isEdited: isEdited, isRemoved: isRemoved, items: items, breadcrumb: breadcrumb())))
    }

    func renderEdit(item: AdminManageContactFormItem, error: String?, permissions: Set<String>) -> HTMLResponse {
        let form = ContactFormForm.State(name: item.name, error: error, success: nil)
        if item.id.isEmpty {
            return renderEngine.renderAdminPage(request: request, title: "Add contact form - Feather CMS", description: "Add contact form", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormAdd(state: .init(form: form, breadcrumb: breadcrumb(label: "Add", path: "/admin/contact/forms/add/"))))
        }
        return renderEngine.renderAdminPage(request: request, title: "Edit contact form - Feather CMS", description: "Edit contact form", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormEdit(state: .init(id: item.id, isEdited: false, form: form, breadcrumb: breadcrumb(label: "Edit", path: "/admin/contact/forms/\(item.id)/edit/"))))
    }

    private func breadcrumb(label: String? = nil, path: String? = nil) -> AdminBreadcrumb.State {
        var links: [AdminBreadcrumb.State.Link] = [.init(label: "Admin", link: "/admin/"), .init(label: "Contact", link: "/admin/contact/"), .init(label: "Forms", link: "/admin/contact/forms/")]
        if let label, let path { links.append(.init(label: label, link: path)) }
        return .init(links: links)
    }
}
