import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminNewsletterSubscribersDirectoryDefaultPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func render(model: AdminNewsletterSubscribersDirectoryModel, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Subscribers - Feather CMS",
            description: "Manage campaign subscribers",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions),
            content: AdminNewsletterSubscribersDirectoryView(
                model: model,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Campaigns", link: "/admin/newsletters/"),
                    .init(label: "Subscribers", link: "")
                ]),
                error: error,
                canRemove: permissions.contains("newsletter:subscribers:delete")
            )
        )
    }

    func renderBulkRemoveConfirmation(search: String?, campaignId: String?, emails: [String], permissions: Set<String>) -> HTMLResponse {
        let query = campaignId?.isEmpty == false ? "?campaignId=\(campaignId!)" : ""
        return renderEngine.renderAdminPage(request: request, title: "Remove selected subscribers - Feather CMS", description: "Confirm subscriber removal", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ListBulkRemoveConfirmation(state: .init(breadcrumb: .init(links: [.init(label: "Admin", link: "/admin/"), .init(label: "Campaigns", link: "/admin/newsletters/"), .init(label: "Subscribers", link: "/admin/newsletters/subscribers/")]), title: "Remove selected subscribers", message: "Are you sure you want to remove the selected subscribers? This action cannot be undone.", action: "/admin/newsletters/subscribers/bulk-remove/\(query)", cancelLink: "/admin/newsletters/subscribers/\(query)", selectedIds: emails)))
    }
}
