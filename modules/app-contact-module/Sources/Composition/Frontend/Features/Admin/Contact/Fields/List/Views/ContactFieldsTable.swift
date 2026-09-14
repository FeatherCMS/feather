import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct ContactFieldsTable: Component {
    struct State {
        let fields: [AdminContactFieldRow]
        let search: String
        let error: String?
        let isEdited: Bool
        let isRemoved: Bool
        let canRemove: Bool
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }
    let state: State
    func html(context: inout RenderContext) -> some BasicTag {
        let basePath = ContactAdminRoutes.fields.description
        return Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Contact form fields",
                        description: "Manage reusable contact form fields."
                    )
                )
            )
            if let error = state.error { P(error).class("error") }
            if state.isEdited { P("Contact form field edited successfully.") }
            if state.isRemoved { P("Contact form field removed successfully.") }
            Div {
                context.render(
                    NewAdminButton(
                        "Add field",
                        href: ContactAdminRoutes.fieldAdd.description
                    )
                )
            }
            .class("button-row")
            Br()
            Br()
            context.render(
                ListTableSearchForm(
                    state: .init(
                        action: "\(basePath)/",
                        placeholder: "Quick search contact fields",
                        search: state.search
                    )
                )
            )
            if state.fields.isEmpty {
                P("No fields yet.")
            }
            else {
                context.render(
                    ListTableRemoveForm(
                        state: .init(
                            action: "\(basePath)/remove/",
                            page: 1,
                            search: state.search,
                            canRemove: state.canRemove,
                            buttonTitle: "Remove selected"
                        ),
                        table: context.render(
                            ListTableShell(
                                table: Table {
                                    Thead {
                                        Tr {
                                            if state.canRemove {
                                                context.render(
                                                    ListTableSelectAllCheckbox()
                                                )
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
                                                    context.render(
                                                        ListTableRowSelectCheckbox(
                                                            state: .init(
                                                                id: field.id
                                                            )
                                                        )
                                                    )
                                                }
                                                Td(field.key)
                                                    .data("label", "Key")
                                                Td(field.label)
                                                    .data("label", "Label")
                                                Td(field.type)
                                                    .data("label", "Type")
                                                Td(
                                                    field.isRequired
                                                        ? "Yes" : "No"
                                                )
                                                .data("label", "Required")
                                                context.render(
                                                    ListTableRowActions(
                                                        state: .init(
                                                            label: "Actions",
                                                            actions: [
                                                                .init(
                                                                    title:
                                                                        "Edit",
                                                                    href:
                                                                        "\(basePath)/\(field.id)/edit/",
                                                                    className:
                                                                        "edit",
                                                                    permission:
                                                                        "contact:form-fields:update"
                                                                ),
                                                                .init(
                                                                    title:
                                                                        "Remove",
                                                                    href:
                                                                        "\(basePath)/\(field.id)/remove/",
                                                                    className:
                                                                        "delete",
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
                                                )
                                            }
                                        }
                                    }
                                }
                                .class("cms-table", "action-table")
                                .if(state.canRemove) {
                                    $0.class("select-table")
                                }
                            )
                        )
                    )
                )
            }
        }
        .class("cms-section")
    }
}
