import HTML
import SGML
import WebStandards

struct ContactFormFieldsTable: Component {
    struct State {
        let formId: String
        let fields: [AdminContactFormFieldRow]
        let search: String
        let error: String?
        let isEdited: Bool
        let isRemoved: Bool
        let canRemove: Bool
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State
    func content() -> some BasicTag {
        let basePath =
            state.formId.isEmpty
            ? "/admin/contact/fields"
            : "/admin/contact/forms/\(state.formId)/items"
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Contact form fields")
            if let error = state.error { P(error).class("error") }
            if state.isEdited { P("Contact form field edited successfully.") }
            if state.isRemoved { P("Contact form field removed successfully.") }
            Div { AdminNavigationButton("Add field", href: "\(basePath)/add/") }
                .class("button-row")
            Br()
            Br()
            ListTableSearchForm(
                state: .init(
                    action: "\(basePath)/",
                    placeholder: "Quick search contact fields",
                    search: state.search
                )
            )
            if state.fields.isEmpty {
                P("No fields yet.")
            }
            else {
                ListTableBulkRemoveForm(
                    state: .init(
                        action: "\(basePath)/bulk-remove/",
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
                                        ListTableSelectAllCheckbox()
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
                                            )
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
                                        )
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                        .if(state.canRemove) { $0.class("bulk-select-table") }
                    )
                )
            }
        }
        .class("cms-section")
    }
}
