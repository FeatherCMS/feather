import Hummingbird

struct AdminContactSubmissionsDirectoryDefaultPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func render(items: [AdminContactSubmissionDirectoryItem], error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Contact submissions - Feather CMS",
            description: "View all contact form submissions",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions),
            content: AdminContactSubmissionsDirectoryView(
                items: items,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Contact", link: "/admin/contact/"),
                    .init(label: "Submissions", link: "")
                ]),
                error: error
            )
        )
    }
}
