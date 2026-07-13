import HTML
import SGML
import WebStandards

struct ContactFormTable: Component {
    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let items: [AdminManageContactFormItem]
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Contact forms")
            if state.isAdded { P("Contact form added successfully.") }
            if state.isEdited { P("Contact form edited successfully.") }
            if state.isRemoved { P("Contact form removed successfully.") }
            Div {
                AdminNavigationButton("Add form", href: "/admin/contact/forms/add/")
            }.class("button-row")
            Br()
            Br()
            if state.items.isEmpty {
                P("No contact forms yet.")
            } else {
                ListTableShell(
                    table: Table {
                        Thead { Tr { Th("Name"); Th("Actions") } }
                        Tbody {
                            for item in state.items {
                                Tr {
                                    Td(item.name).data("label", "Name")
                                    ListTableRowActions(state: .init(label: "Actions", actions: [
                                        .init(title: "Fields", href: "/admin/contact/forms/\(item.id)/items/", className: nil, permission: "contact:form-items:list"),
                                        .init(title: "Submissions", href: "/admin/contact/forms/\(item.id)/submissions/", className: nil, permission: "contact:form-submissions:list"),
                                        .init(title: "Edit", href: "/admin/contact/forms/\(item.id)/edit/", className: "edit", permission: "contact:forms:update"),
                                        .init(title: "Remove", href: "/admin/contact/forms/\(item.id)/remove/", className: "delete", permission: "contact:forms:delete")
                                    ], permissions: ["contact:form-items:list", "contact:form-submissions:list", "contact:forms:update", "contact:forms:delete"]))
                                }
                            }
                        }
                    }.class("cms-table", "action-table")
                )
            }
        }.class("cms-section")
    }
}
