import ContactContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormSubmissionsTableContent: Component {
    let formId: String
    let items: [AdminContactFormSubmissionItem]
    let pageState: AdminListPageState
    let search: String
    let permissions: AdminListActions

    private var hasEmailColumn: Bool {
        items.contains { !($0.email?.isEmpty ?? true) }
    }

    func html(context: inout BuilderContext) -> Div {
        let path = ContactAdminRoutes.formSubmissions(RouterPath(formId))
            .description
        return context.build(
            AdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            AdminListInvalidPageState(
                                pageState: pageState,
                                path: path
                            )
                        )
                    }
                    else if items.isEmpty {
                        context.build(
                            AdminListEmptyState(
                                message: search.isEmpty
                                    ? "No submissions yet."
                                    : "No submissions match your search.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if !search.isEmpty {
                                        context.build(
                                            AdminButton(
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
                            AdminListSelectionForm(
                                state: .init(
                                    action:
                                        ContactAdminRoutes.formSubmissionRemove(
                                            RouterPath(formId)
                                        )
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
                                    AdminListShell(
                                        layout: .init(
                                            name: "contact-form-submissions",
                                            columns: [
                                                .fraction(1), .fraction(1),
                                                .fixed(150), .fixed(220),
                                            ]
                                        ),
                                        hasSelection: canDelete,
                                        table: Table {
                                            Thead {
                                                Tr {
                                                    if canDelete {
                                                        context.build(
                                                            AdminListSelectAllCheckbox()
                                                        )
                                                    }
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
                                                                AdminListRowCheckbox(
                                                                    id: item.id
                                                                )
                                                            )
                                                        }
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
                                                            AdminListRowActions(
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
                                                                                        formId
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
                        AdminListSearch(
                            state: .init(
                                action: path,
                                placeholder: "Quick search submissions",
                                search: search
                            )
                        )
                    )
                },
                pagination: {
                    context.build(
                        AdminListPagination(
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
