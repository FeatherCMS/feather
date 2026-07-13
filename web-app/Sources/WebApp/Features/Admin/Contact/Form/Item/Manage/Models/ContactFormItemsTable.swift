import HTML
import SGML
import WebStandards

struct ContactFormItemsTable: Component {
    struct State { let formId: String; let items: [AdminManageContactFormItemRow]; let error: String?; let isEdited: Bool; let isRemoved: Bool; let breadcrumb: AdminBreadcrumb.State }
    let state: State
    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Contact form fields")
            if let error = state.error { P(error).class("error") }
            if state.isEdited { P("Contact form field edited successfully.") }
            if state.isRemoved { P("Contact form field removed successfully.") }
            Div { AdminNavigationButton("Add field", href: "/admin/contact/forms/\(state.formId)/items/add/") }.class("button-row"); Br(); Br()
            if state.items.isEmpty { P("No fields yet.") } else {
                ListTableShell(table: Table {
                    Thead { Tr { Th("Key"); Th("Label"); Th("Type"); Th("Required"); Th("Position"); Th("Actions") } }
                    Tbody { for item in state.items { Tr { Td(item.key); Td(item.label); Td(item.type); Td(item.isRequired ? "Yes" : "No"); Td(item.position); ListTableRowActions(state: .init(label: "Actions", actions: [.init(title: "Edit", href: "/admin/contact/forms/\(state.formId)/items/\(item.id)/edit/", className: "edit", permission: "contact:form-items:update"), .init(title: "Remove", href: "/admin/contact/forms/\(state.formId)/items/\(item.id)/remove/", className: "delete", permission: "contact:form-items:delete")], permissions: ["contact:form-items:update", "contact:form-items:delete"])) } } }
                }.class("cms-table", "action-table"))
            }
        }.class("cms-section")
    }
}
