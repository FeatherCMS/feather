import ContactContracts
import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormFieldsTableContent: Component {
    let formId: String
    let fields: [AdminContactFormFieldRow]
    let pageState: NewAdminListPageState
    let search: String
    let permissions: NewAdminListActions

    func html(context: inout RenderContext) -> Div {
        let path = ContactAdminRoutes.formFields(RouterPath(formId)).description
        let returnTo = NewAdminLocation.url(
            path: path,
            page: pageState.page,
            search: search
        )
        return context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: path
                            )
                        )
                    }
                    else if fields.isEmpty {
                        context.render(
                            NewAdminListEmptyState(
                                message: search.isEmpty
                                    ? "No fields in this form yet."
                                    : "No fields match your search.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if search.isEmpty {
                                        if permissions.allows(
                                            ContactPermissions.Fields.create
                                        ) {
                                            context.render(
                                                NewAdminButton(
                                                    "Add field",
                                                    href:
                                                        ContactAdminRoutes
                                                        .formFieldAdd(
                                                            RouterPath(formId)
                                                        )
                                                        .description
                                                )
                                            )
                                        }
                                    }
                                    else {
                                        context.render(
                                            NewAdminButton(
                                                "Reset search",
                                                href: path,
                                                style: .secondary
                                            )
                                        )
                                    }
                                }
                            )
                        )
                    }
                    else {
                        let canDelete = permissions.allows(
                            ContactPermissions.Fields.delete
                        )
                        context.render(
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: NewAdminLocation.remove(
                                        path:
                                            ContactAdminRoutes.formFieldRemove(
                                                RouterPath(formId)
                                            )
                                            .description,
                                        ids: [],
                                        returnTo: returnTo
                                    ),
                                    pageState: pageState,
                                    search: search,
                                    button: .init(
                                        "Remove selected",
                                        style: .destructive
                                    ),
                                    isEnabled: canDelete
                                ),
                                table: context.render(
                                    NewAdminListShell(
                                        layout: .init(
                                            name: "contact-form-fields",
                                            columns: [
                                                .fraction(1), .fraction(1),
                                                .fraction(1), .fixed(110),
                                                .fixed(220),
                                            ]
                                        ),
                                        hasSelection: canDelete,
                                        table: Table {
                                            Thead {
                                                Tr {
                                                    if canDelete {
                                                        context.render(
                                                            NewAdminListSelectAllCheckbox()
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
                                                for field in fields {
                                                    Tr {
                                                        if canDelete {
                                                            context.render(
                                                                NewAdminListRowCheckbox(
                                                                    id: field.id
                                                                )
                                                            )
                                                        }
                                                        Td(field.key)
                                                            .data(
                                                                "label",
                                                                "Key"
                                                            )
                                                        Td(field.label)
                                                            .data(
                                                                "label",
                                                                "Label"
                                                            )
                                                        Td {
                                                            context.render(
                                                                typeChip(
                                                                    field.type
                                                                )
                                                            )
                                                        }
                                                        .data("label", "Type")
                                                        Td(
                                                            field.isRequired
                                                                ? "Yes" : "No"
                                                        )
                                                        .data(
                                                            "label",
                                                            "Required"
                                                        )
                                                        context.render(
                                                            NewAdminListRowActions(
                                                                label:
                                                                    "Actions",
                                                                actions: [
                                                                    .init(
                                                                        "Edit",
                                                                        href:
                                                                            ContactAdminRoutes
                                                                            .formFieldEdit(
                                                                                formID:
                                                                                    RouterPath(
                                                                                        formId
                                                                                    ),
                                                                                fieldID:
                                                                                    RouterPath(
                                                                                        field
                                                                                            .id
                                                                                    )
                                                                            )
                                                                            .description,
                                                                        style:
                                                                            .ghost(
                                                                                .secondary
                                                                            ),
                                                                        permission:
                                                                            ContactPermissions
                                                                            .Fields
                                                                            .update
                                                                    ),
                                                                    .init(
                                                                        "Remove",
                                                                        href:
                                                                            NewAdminLocation
                                                                            .remove(
                                                                                path:
                                                                                    ContactAdminRoutes
                                                                                    .formFieldRemove(
                                                                                        formID:
                                                                                            RouterPath(
                                                                                                formId
                                                                                            ),
                                                                                        fieldID:
                                                                                            RouterPath(
                                                                                                field
                                                                                                    .id
                                                                                            )
                                                                                    )
                                                                                    .description,
                                                                                ids: [
                                                                                    field
                                                                                        .id
                                                                                ],
                                                                                returnTo:
                                                                                    returnTo
                                                                            ),
                                                                        style:
                                                                            .destructive,
                                                                        permission:
                                                                            ContactPermissions
                                                                            .Fields
                                                                            .delete
                                                                    ),
                                                                ],
                                                                permissions:
                                                                    permissions
                                                            )
                                                        )
                                                    }
                                                }
                                            }
                                        }
                                        .class("cms-table", "action-table")
                                        .if(canDelete) {
                                            $0.class("select-table")
                                        }
                                    )
                                )
                            )
                        )
                    }
                },
                search: {
                    context.render(
                        NewAdminListSearch(
                            state: .init(
                                action: path,
                                placeholder: "Quick search contact fields",
                                search: search
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(ContactPermissions.Fields.create) {
                        context.render(
                            NewAdminListToolbar {
                                context.render(
                                    NewAdminButton(
                                        "Add field",
                                        href:
                                            ContactAdminRoutes.formFieldAdd(
                                                RouterPath(formId)
                                            )
                                            .description
                                    )
                                )
                            }
                        )
                    }
                },
                pagination: {
                    context.render(
                        NewAdminListPagination(
                            state: .init(
                                path: path,
                                pageState: pageState,
                                search: search
                            )
                        )
                    )
                }
            )
        )
    }

    private func typeChip(_ type: String) -> NewAdminChip {
        let color: NewAdminChip.ColorName
        switch type.lowercased() {
        case "textarea": color = .purple
        case "select": color = .green
        case "radio": color = .orange
        case "toggle": color = .yellow
        default: color = .blue
        }
        return .init(label: type.capitalized, color: color)
    }
}
