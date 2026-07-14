import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminManageContactFormSubmissionsDefaultPresenter: AdminManageContactFormSubmissionsPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderList(formId: String, items: [AdminManageContactFormSubmissionRow], search: String, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Contact form submissions - Feather CMS", description: "Track contact form submissions", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormSubmissionsTable(state: .init(formId: formId, items: items, search: search, error: error, breadcrumb: breadcrumb(formId: formId), canRemove: permissions.contains("contact:form-submissions:delete"))))
    }

    func renderRemoveConfirmation(formId: String, item: AdminManageContactFormSubmissionRow, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Remove contact form submission - Feather CMS", description: "Remove contact form submission", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ListBulkRemoveConfirmation(state: .init(breadcrumb: breadcrumb(formId: formId, label: "Remove"), title: "Remove contact form submission", message: "Are you sure you want to remove this contact form submission? This action cannot be undone.", action: "/admin/contact/forms/\(formId)/submissions/bulk-remove/", cancelLink: "/admin/contact/forms/\(formId)/submissions/", selectedIds: [item.id])))
    }

    func renderBulkRemoveConfirmation(formId: String, selectedIds: [String], permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Remove contact form submissions - Feather CMS", description: "Remove contact form submissions", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ListBulkRemoveConfirmation(state: .init(breadcrumb: breadcrumb(formId: formId, label: "Remove"), title: "Remove contact form submissions", message: "Are you sure you want to remove the selected contact form submissions? This action cannot be undone.", action: "/admin/contact/forms/\(formId)/submissions/bulk-remove/", cancelLink: "/admin/contact/forms/\(formId)/submissions/", selectedIds: selectedIds)))
    }

    func renderDetail(formId: String, item: AdminManageContactFormSubmissionRow, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Contact form submission - Feather CMS", description: "View contact form submission", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormSubmissionDetailView(state: .init(formId: formId, item: item, error: error, isEdited: request.hasQueryFlag("edited"), breadcrumb: breadcrumb(formId: formId, label: "Details"))))
    }

    private func breadcrumb(formId: String, label: String? = nil) -> AdminBreadcrumb.State {
        var links: [AdminBreadcrumb.State.Link] = [.init(label: "Admin", link: "/admin/"), .init(label: "Contact", link: "/admin/contact/"), .init(label: "Forms", link: "/admin/contact/forms/"), .init(label: "Submissions", link: "/admin/contact/forms/\(formId)/submissions/")]
        if let label { links.append(.init(label: label, link: "")) }
        return .init(links: links)
    }
}
