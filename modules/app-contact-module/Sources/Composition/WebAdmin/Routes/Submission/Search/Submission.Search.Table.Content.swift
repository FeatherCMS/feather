import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension Submission.Search.Table {
    struct Content: Component {
        let items: [Submission.Search.Model.Item]
        let pageState: AdminListPageState
        let search: String
        let formKey: String?
        let routes: Submission.Router.Routes
        let permissions: AdminListActions

        private var hasEmailColumn: Bool {
            items.contains { !($0.email?.isEmpty ?? true) }
        }

        func html(context: inout BuilderContext) -> Div {
            let path =
                formKey.map {
                    routes.formSubmissions.path(parameter: "formKey", value: $0)
                } ?? routes.submissions.path
            let removePath =
                formKey.map {
                    routes.formSubmissionRemoveSelectedPath($0)
                } ?? routes.submissionsRemove.path
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
                                Submission.Permissions.delete
                            )
                            context.build(
                                AdminListSelectionForm(
                                    state: .init(
                                        action: removePath,
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
                                                name: "contact-submissions",
                                                columns: [
                                                    .fraction(1), .fraction(1),
                                                    .fraction(1), .fixed(150),
                                                    .actions,
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
                                                                    AdminListRowCheckbox(
                                                                        id:
                                                                            formKey
                                                                            == nil
                                                                            ? "\(item.formKey):\(item.id)"
                                                                            : item
                                                                                .id
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
                                                                AdminListRowActions(
                                                                    label:
                                                                        "Actions",
                                                                    actions: [
                                                                        .init(
                                                                            "Details",
                                                                            href:
                                                                                routes
                                                                                .formSubmissionDetailPath(
                                                                                    formKey:
                                                                                        item
                                                                                        .formKey,
                                                                                    submissionId:
                                                                                        item
                                                                                        .id
                                                                                ),
                                                                            style:
                                                                                .ghost(
                                                                                    .primary
                                                                                ),
                                                                            permission:
                                                                                Submission
                                                                                .Permissions
                                                                                .read
                                                                        )
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
                                    placeholder:
                                        "Quick search contact submissions",
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
}
