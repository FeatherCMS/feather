import Hummingbird

struct AdminManageNewslettersDefaultPresenter: AdminManageNewslettersPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderList(items: [AdminManageNewsletterItem], isAdded: Bool, isEdited: Bool, isRemoved: Bool, isPicker: Bool, error: String?, permissions: Set<String>, search: String) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Campaigns - Feather CMS", description: "Manage campaigns", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: NewsletterTable(state: .init(isAdded: isAdded, isEdited: isEdited, isRemoved: isRemoved, items: items, search: search, permissions: permissions, isPicker: isPicker, breadcrumb: breadcrumb())))
    }

    func renderBulkRemoveConfirmation(page: Int, search: String, selectedIds: [String], permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Remove campaigns - Feather CMS", description: "Remove campaigns", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ListBulkRemoveConfirmation(state: .init(breadcrumb: breadcrumb(), title: "Remove campaigns", message: "Are you sure you want to remove the selected campaigns? This action cannot be undone.", action: "/admin/newsletters/bulk-remove/", cancelLink: ListBulkRemoveRedirect.location(path: "/admin/newsletters/", page: page, search: search, title: nil, message: nil), selectedIds: selectedIds)))
    }

    func renderEdit(item: AdminManageNewsletterItem, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Campaign details - Feather CMS", description: "Manage campaign details", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: NewsletterEdit(state: .init(id: item.id, isEdited: false, form: .init(name: item.name, error: error, success: nil), breadcrumb: breadcrumb(label: "Details", path: "/admin/newsletters/\(item.id)/details/"))))
    }

    private func breadcrumb(label: String? = nil, path: String? = nil) -> AdminBreadcrumb.State {
        var links: [AdminBreadcrumb.State.Link] = [.init(label: "Admin", link: "/admin/"), .init(label: "Campaigns", link: "/admin/newsletters/")]
        if let label, let path { links.append(.init(label: label, link: path)) }
        return .init(links: links)
    }
}
