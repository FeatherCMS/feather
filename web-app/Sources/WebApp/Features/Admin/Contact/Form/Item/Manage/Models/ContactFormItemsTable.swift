import HTML
import SGML
import WebStandards

struct ContactFormItemsTable: Component {
    struct State { let formId: String; let items: [AdminManageContactFormItemRow]; let search: String; let error: String?; let isEdited: Bool; let isRemoved: Bool; let canRemove: Bool; let breadcrumb: AdminBreadcrumb.State }
    let state: State
    func content() -> some BasicTag {
        let basePath = state.formId == "__global_contact_fields__" ? "/admin/contact/fields" : "/admin/contact/forms/\(state.formId)/items"
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Contact form fields")
            if let error = state.error { P(error).class("error") }
            if state.isEdited { P("Contact form field edited successfully.") }
            if state.isRemoved { P("Contact form field removed successfully.") }
            Div { AdminNavigationButton("Add field", href: "\(basePath)/add/") }.class("button-row"); Br(); Br()
            ListTableSearchForm(state: .init(action: "\(basePath)/", placeholder: "Quick search contact fields", search: state.search))
            if state.items.isEmpty { P("No fields yet.") } else {
                ListTableBulkRemoveForm(
                    state: .init(action: "\(basePath)/bulk-remove/", page: 1, search: state.search, canRemove: state.canRemove, buttonTitle: "Remove selected"),
                    table: ListTableShell(table: Table {
                        Thead { Tr { if state.canRemove { ListTableSelectAllCheckbox() }; Th("Key"); Th("Label"); Th("Type"); Th("Required"); Th("Actions") } }
                        Tbody { for item in state.items { Tr { if state.canRemove { ListTableRowSelectCheckbox(state: .init(id: item.id)) }; Td(item.key).data("label", "Key"); Td(item.label).data("label", "Label"); Td(item.type).data("label", "Type"); Td(item.isRequired ? "Yes" : "No").data("label", "Required"); ListTableRowActions(state: .init(label: "Actions", actions: [.init(title: "Edit", href: "\(basePath)/\(item.id)/edit/", className: "edit", permission: "contact:form-items:update"), .init(title: "Remove", href: "\(basePath)/\(item.id)/remove/", className: "delete", permission: "contact:form-items:delete")], permissions: ["contact:form-items:update", "contact:form-items:delete"])) } } }
                    }.class("cms-table", "action-table").if(state.canRemove) { $0.class("bulk-select-table") })
                )
            }
        }.class("cms-section")
    }
}
