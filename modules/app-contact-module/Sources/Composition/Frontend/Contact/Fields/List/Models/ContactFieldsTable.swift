import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFieldsTable: Leaf {
    struct State {
        let fields: [AdminContactFieldRow]
        let search: String
        let error: String?
        let isEdited: Bool
        let isRemoved: Bool
        let canRemove: Bool
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State
    func html() -> some BasicTag {
        let basePath = "/admin/contact/fields"
        return Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("Contact form fields")
            if let error = state.error { P(error).class("error") }
            if state.isEdited { P("Contact form field edited successfully.") }
            if state.isRemoved { P("Contact form field removed successfully.") }
            Div { AdminNavigationButton("Add field", href: "\(basePath)/add/").html() }
                .class("button-row")
            Br()
            Br()
            ListTableSearchForm(
                state: .init(
                    action: "\(basePath)/",
                    placeholder: "Quick search contact fields",
                    search: state.search
                )
            ).html()
            if state.fields.isEmpty {
                P("No fields yet.")
            }
            else {
                ListTableRemoveForm(
                    state: .init(
                        action: "\(basePath)/remove/",
                        page: 1,
                        search: state.search,
                        canRemove: state.canRemove,
                        buttonTitle: "Remove selected"
                    ),
                    table: ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    if state.canRemove {
                                        ListTableSelectAllCheckbox().html()
                                    }
                                    Th("Key")
                                    Th("Label")
                                    Th("Type")
                                    Th("Required")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for field in state.fields {
                                    Tr {
                                        if state.canRemove {
                                            ListTableRowSelectCheckbox(
                                                state: .init(id: field.id)
                                            ).html()
                                        }
                                        Td(field.key).data("label", "Key")
                                        Td(field.label).data("label", "Label")
                                        Td(field.type).data("label", "Type")
                                        Td(field.isRequired ? "Yes" : "No")
                                            .data("label", "Required")
                                        ListTableRowActions(
                                            state: .init(
                                                label: "Actions",
                                                actions: [
                                                    .init(
                                                        title: "Edit",
                                                        href:
                                                            "\(basePath)/\(field.id)/edit/",
                                                        className: "edit",
                                                        permission:
                                                            "contact:form-fields:update"
                                                    ),
                                                    .init(
                                                        title: "Remove",
                                                        href:
                                                            "\(basePath)/\(field.id)/remove/",
                                                        className: "delete",
                                                        permission:
                                                            "contact:form-fields:delete"
                                                    ),
                                                ],
                                                permissions: [
                                                    "contact:form-fields:update",
                                                    "contact:form-fields:delete",
                                                ]
                                            )
                                        ).html()
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                        .if(state.canRemove) { $0.class("select-table") }
                    ).html()
                ).html()
            }
        }
        .class("cms-section")
    }
}
