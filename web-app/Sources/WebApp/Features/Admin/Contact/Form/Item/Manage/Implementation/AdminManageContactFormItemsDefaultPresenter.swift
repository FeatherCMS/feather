import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminManageContactFormItemsDefaultPresenter: AdminManageContactFormItemsPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderList(formId: String, items: [AdminManageContactFormItemRow], search: String, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Contact form fields - Feather CMS", description: "Manage contact form fields", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormItemsTable(state: .init(formId: formId, items: items, search: search, error: error, isEdited: request.hasQueryFlag("edited"), isRemoved: request.hasQueryFlag("removed"), canRemove: permissions.contains("contact:form-items:delete"), breadcrumb: breadcrumb(formId: formId))))
    }

    func renderBulkRemoveConfirmation(formId: String, selectedIds: [String], permissions: Set<String>) -> HTMLResponse {
        let basePath = formId == "__global_contact_fields__" ? "/admin/contact/fields" : "/admin/contact/forms/\(formId)/items"
        return renderEngine.renderAdminPage(request: request, title: "Remove contact form fields - Feather CMS", description: "Remove contact form fields", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ListBulkRemoveConfirmation(state: .init(breadcrumb: breadcrumb(formId: formId, label: "Remove"), title: "Remove contact form fields", message: "Are you sure you want to remove the selected contact form fields? This action cannot be undone.", action: "\(basePath)/bulk-remove/", cancelLink: "\(basePath)/", selectedIds: selectedIds)))
    }

    func renderEdit(formId: String, item: AdminManageContactFormItemRow, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Edit contact form field - Feather CMS", description: "Edit contact form field", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormItemEditView(state: .init(formId: formId, item: item, error: error, breadcrumb: breadcrumb(formId: formId, label: "Edit"))))
    }

    func renderRemoveConfirmation(formId: String, itemId: String, label: String, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Remove contact form field - Feather CMS", description: "Remove contact form field", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormItemRemoveView(formId: formId, itemId: itemId, label: label, breadcrumb: breadcrumb(formId: formId, label: "Remove")))
    }

    private func breadcrumb(formId: String, label: String? = nil) -> AdminBreadcrumb.State {
        var links: [AdminBreadcrumb.State.Link] = [.init(label: "Admin", link: "/admin/"), .init(label: "Contact", link: "/admin/contact/"), .init(label: "Forms", link: "/admin/contact/forms/"), .init(label: "Fields", link: "/admin/contact/forms/\(formId)/items/")]
        if let label { links.append(.init(label: label, link: "")) }
        return .init(links: links)
    }
}
