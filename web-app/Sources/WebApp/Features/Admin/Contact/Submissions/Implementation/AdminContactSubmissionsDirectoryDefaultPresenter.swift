import Hummingbird

struct AdminContactSubmissionsDirectoryDefaultPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func render(items: [AdminContactSubmissionDirectoryItem], search: String, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Contact submissions - Feather CMS",
            description: "View all contact form submissions",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions),
            content: AdminContactSubmissionsDirectoryView(
                items: items,
                search: search,
                canRemove: permissions.contains("contact:form-submissions:delete"),
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Contact", link: "/admin/contact/"),
                    .init(label: "Submissions", link: "")
                ]),
                error: error
            )
        )
    }

    func renderBulkRemoveConfirmation(selectedIds: [String], permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Remove contact submissions - Feather CMS", description: "Remove contact submissions", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ListBulkRemoveConfirmation(state: .init(breadcrumb: .init(links: [.init(label: "Admin", link: "/admin/"), .init(label: "Contact", link: "/admin/contact/"), .init(label: "Submissions", link: "/admin/contact/submissions/")]), title: "Remove contact submissions", message: "Are you sure you want to remove the selected contact submissions? This action cannot be undone.", action: "/admin/contact/submissions/bulk-remove/", cancelLink: "/admin/contact/submissions/", selectedIds: selectedIds)))
    }
}
