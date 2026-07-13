import HTML
import SGML
import WebStandards

struct ContactFormSubmissionsTable: Component {
    struct State { let formId: String; let items: [AdminManageContactFormSubmissionRow]; let error: String?; let breadcrumb: AdminBreadcrumb.State }
    let state: State
    func content() -> some BasicTag {
        Section { AdminBreadcrumb(state: state.breadcrumb); H1("Contact form submissions"); if let error = state.error { P(error).class("error") }; if state.items.isEmpty { P("No submissions yet.") } else { ListTableShell(table: Table { Thead { Tr { Th("Submitted"); Th("Status"); Th("Actions") } }; Tbody { for item in state.items { Tr { Td(item.submittedAt); Td(item.status); ListTableRowActions(state: .init(label: "Actions", actions: [.init(title: "Details", href: "/admin/contact/forms/\(state.formId)/submissions/\(item.id)/", className: nil, permission: "contact:form-submissions:read")], permissions: ["contact:form-submissions:read"])) } } } }.class("cms-table", "action-table")) } }.class("cms-section")
    }
}
