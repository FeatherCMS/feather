import ContactContracts
import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct ContactSubmissionsTableContent: Component {
    let items: [AdminContactSubmissionDirectoryItem]
    let pageState: NewAdminListPageState
    let search: String
    let permissions: NewAdminListActions

    private var hasEmailColumn: Bool {
        items.contains { !($0.email?.isEmpty ?? true) }
    }

    func html(context: inout BuilderContext) -> Div {
        let path = ContactAdminRoutes.submissions.description
        let returnTo = NewAdminLocation.url(
            path: path,
            page: pageState.page,
            search: search
        )
        return context.build(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: path
                            )
                        )
                    }
                    else if items.isEmpty {
                        context.build(
                            NewAdminListEmptyState(
                                message: search.isEmpty
                                    ? "No submissions yet."
                                    : "No submissions match your search.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if !search.isEmpty {
                                        context.build(
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
                            ContactPermissions.Submissions.delete
                        )
                        context.build(
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: ContactAdminRoutes.submissionRemove
                                        .description,
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
                                            name: "contact-submissions",
                                            columns: [
                                                .fraction(1), .fraction(1),
                                                .fraction(1), .fixed(150),
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
                                                    Th("Form")
                                                    Th("Submitted")
                                                    if hasEmailColumn {
                                                        Th("Email")
                                                    }
                                                    Th("Status")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for item in items {
                                                    Tr {
                                                        if canDelete {
                                                            context.build(
                                                                NewAdminListRowCheckbox(
                                                                    id:
                                                                        "\(item.formId):\(item.id)"
                                                                )
                                                            )
                                                        }
                                                        Td(item.formName)
                                                            .data(
                                                                "label",
                                                                "Form"
                                                            )
                                                        Td(item.createdAt)
                                                            .data(
                                                                "label",
                                                                "Submitted"
                                                            )
                                                        if hasEmailColumn {
                                                            Td(
                                                                item.email
                                                                    ?? "—"
                                                            )
                                                            .data(
                                                                "label",
                                                                "Email"
                                                            )
                                                        }
                                                        Td(item.status)
                                                            .data(
                                                                "label",
                                                                "Status"
                                                            )
                                                        context.build(
                                                            NewAdminListRowActions(
                                                                label:
                                                                    "Actions",
                                                                actions: [
                                                                    .init(
                                                                        "Details",
                                                                        href:
                                                                            ContactAdminRoutes
                                                                            .formSubmissionDetails(
                                                                                formID:
                                                                                    RouterPath(
                                                                                        item
                                                                                            .formId
                                                                                    ),
                                                                                submissionID:
                                                                                    RouterPath(
                                                                                        item
                                                                                            .id
                                                                                    )
                                                                            )
                                                                            .description,
                                                                        style:
                                                                            .ghost(
                                                                                .primary
                                                                            ),
                                                                        permission:
                                                                            ContactPermissions
                                                                            .Submissions
                                                                            .read
                                                                    ),
                                                                    .init(
                                                                        "Remove",
                                                                        href:
                                                                            NewAdminLocation
                                                                            .remove(
                                                                                path:
                                                                                    ContactAdminRoutes
                                                                                    .formSubmissionRemove(
                                                                                        formID:
                                                                                            RouterPath(
                                                                                                item
                                                                                                    .formId
                                                                                            ),
                                                                                        submissionID:
                                                                                            RouterPath(
                                                                                                item
                                                                                                    .id
                                                                                            )
                                                                                    )
                                                                                    .description,
                                                                                ids: [
                                                                                    item
                                                                                        .id
                                                                                ],
                                                                                returnTo:
                                                                                    returnTo
                                                                            ),
                                                                        style:
                                                                            .destructive,
                                                                        permission:
                                                                            ContactPermissions
                                                                            .Submissions
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
                                action: path,
                                placeholder: "Quick search contact submissions",
                                search: search
                            )
                        )
                    )
                },
                pagination: {
                    context.build(
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
}
