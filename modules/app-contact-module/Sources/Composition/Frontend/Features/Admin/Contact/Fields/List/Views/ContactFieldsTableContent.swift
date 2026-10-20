import ContactContracts
import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFieldsTableContent: Component {
    let fields: [AdminContactFieldRow]
    let forms: [AdminContactFormFilterOption]
    let formKey: String?
    let pageState: NewAdminListPageState
    let search: String
    let permissions: NewAdminListActions

    func html(context: inout BuilderContext) -> Div {
        let returnTo = NewAdminLocation.url(
            path: ContactAdminRoutes.fields.description,
            page: pageState.page,
            search: search,
            queryItems: formKey.map { [("form", $0)] } ?? []
        )
        return context.build(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: ContactAdminRoutes.fields.description
                            )
                        )
                    }
                    else if fields.isEmpty {
                        context.build(
                            NewAdminListEmptyState(
                                message: search.isEmpty && formKey == nil
                                    ? "No contact form fields yet."
                                    : formKey == nil
                                        ? "No contact form fields match your search."
                                        : search.isEmpty
                                            ? "This form has no assigned fields."
                                            : "No assigned fields match your search.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if search.isEmpty && formKey == nil {
                                        if permissions.allows(
                                            ContactPermissions.Fields.create
                                        ) {
                                            context.build(
                                                NewAdminButton(
                                                    "Add field",
                                                    href: ContactAdminRoutes
                                                        .fieldAdd.description
                                                )
                                            )
                                        }
                                    }
                                    else if !search.isEmpty {
                                        context.build(
                                            NewAdminButton(
                                                "Reset search",
                                                href: NewAdminLocation.url(
                                                    path: ContactAdminRoutes
                                                        .fields.description,
                                                    queryItems: formKey.map {
                                                        [("form", $0)]
                                                    } ?? []
                                                ),
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
                        context.build(
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: NewAdminLocation.remove(
                                        path: ContactAdminRoutes.fieldRemove
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
                                table: context.build(
                                    NewAdminListShell(
                                        layout: .init(
                                            name: "contact-fields",
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
                                                        context.build(
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
                                                            context.build(
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
                                                            context.build(
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
                                                        context.build(
                                                            NewAdminListRowActions(
                                                                label:
                                                                    "Actions",
                                                                actions: [
                                                                    .init(
                                                                        "Edit",
                                                                        href:
                                                                            ContactAdminRoutes
                                                                            .fields
                                                                            .appendingPath(
                                                                                RouterPath(
                                                                                    field
                                                                                        .id
                                                                                )
                                                                            )
                                                                            .appendingPath(
                                                                                RouterPath(
                                                                                    "edit"
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
                                                                                    .fieldRemove
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
                    context.build(
                        NewAdminListSearch(
                            state: .init(
                                action: ContactAdminRoutes.fields.description,
                                placeholder: "Quick search contact fields",
                                search: search,
                                resetPath: NewAdminLocation.url(
                                    path: ContactAdminRoutes.fields.description,
                                    queryItems: formKey.map { [("form", $0)] }
                                        ?? []
                                )
                            ),
                            additionalFields: {
                                Label {
                                    Span("Form").class("visually-hidden")
                                    Select {
                                        Option("All forms").value("")
                                            .if(formKey == nil) {
                                                $0.selected()
                                            }
                                        for form in forms {
                                            Option(form.name)
                                                .value(form.key)
                                                .if(form.key == formKey) {
                                                    $0.selected()
                                                }
                                        }
                                    }
                                    .name("form")
                                    .ariaLabel("Filter fields by form")
                                    .class("form-filter-select")
                                }
                            }
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(ContactPermissions.Fields.create) {
                        context.build(
                            NewAdminListToolbar {
                                context.build(
                                    NewAdminButton(
                                        "Add field",
                                        href: ContactAdminRoutes.fieldAdd
                                            .description
                                    )
                                )
                            }
                        )
                    }
                },
                pagination: {
                    context.build(
                        NewAdminListPagination(
                            state: .init(
                                path: ContactAdminRoutes.fields.description,
                                pageState: pageState,
                                search: search,
                                queryItems: formKey.map {
                                    [.init(name: "form", value: $0)]
                                } ?? []
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
        case "hidden": color = .gray
        default: color = .blue
        }
        return .init(label: type.capitalized, color: color)
    }
}
