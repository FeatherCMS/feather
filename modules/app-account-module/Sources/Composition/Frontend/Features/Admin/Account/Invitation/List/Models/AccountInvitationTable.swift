import AccountAdminAPI
import AccountContracts
import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AccountInvitationTable: Component {
    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: AdminListActions
        let invitations: [Components.Schemas.AccountInvitationListItemSchema]
        let pageState: AdminListPageState
        let search: String
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        let canDelete = state.permissions.allows(
            AccountPermissions.Invitations.delete
        )

        return Div {
            context.build(
                AdminBreadcrumb(
                    links: AccountAdminRoutes.invitationBreadcrumb
                )
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "User invitations",
                        description:
                            "Manage invitations sent to prospective users."
                    )
                )
            )
            context.build(
                AdminList(
                    table: {
                        if !state.canAccess {
                            context.build(
                                AdminStatusView(
                                    state: .init(
                                        title: "Forbidden",
                                        message:
                                            "Your identity cannot access user invitations."
                                    ),
                                    icon: FeatherIcons.alertCircle()
                                )
                            )
                        }
                        else if state.pageState.isPageOutOfRange {
                            context.build(
                                AdminListInvalidPageState(
                                    pageState: state.pageState,
                                    path: AccountAdminRoutes.invitations
                                        .description
                                )
                            )
                        }
                        else if state.invitations.isEmpty {
                            context.build(
                                AdminListEmptyState(
                                    message: state.search.isEmpty
                                        ? "No user invitations yet."
                                        : "No invitations match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if !state.search.isEmpty {
                                            context.build(
                                                AdminButton(
                                                    "Reset search",
                                                    href: AccountAdminRoutes
                                                        .invitations
                                                        .description,
                                                    style: .secondary
                                                )
                                            )
                                        }
                                        else if state.permissions.allows(
                                            AccountPermissions.Invitations
                                                .create
                                        ) {
                                            context.build(
                                                AdminButton(
                                                    "Add new",
                                                    href: AccountAdminRoutes
                                                        .invitationAdd
                                                        .description
                                                )
                                            )
                                        }
                                    }
                                )
                            )
                        }
                        else {
                            context.build(
                                AdminListSelectionForm(
                                    state: .init(
                                        action: AccountAdminRoutes
                                            .invitationRemoveBulk.description,
                                        pageState: state.pageState,
                                        search: state.search,
                                        button: .init(
                                            "Remove selected",
                                            style: .destructive
                                        ),
                                        isEnabled: canDelete
                                    ),
                                    table: context.build(
                                        AdminListShell(
                                            layout: .init(
                                                name: "account-invitations",
                                                columns: [
                                                    .fixed(260),
                                                    .fraction(1),
                                                    .fixed(220),
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
                                                        Th("Email")
                                                        Th("Expires at")
                                                        Th("Actions")
                                                    }
                                                }
                                                Tbody {
                                                    for invitation in state
                                                        .invitations
                                                    {
                                                        Tr {
                                                            if canDelete {
                                                                context.build(
                                                                    AdminListRowCheckbox(
                                                                        id:
                                                                            invitation
                                                                            .id
                                                                    )
                                                                )
                                                            }
                                                            Td(invitation.email)
                                                                .data(
                                                                    "label",
                                                                    "Email"
                                                                )
                                                            Td(
                                                                DateFormatting
                                                                    .formatUnixTimestamp(
                                                                        invitation
                                                                            .expiresAt
                                                                    )
                                                            )
                                                            .data(
                                                                "label",
                                                                "Expires at"
                                                            )
                                                            context.build(
                                                                AdminListRowActions(
                                                                    label:
                                                                        "Actions",
                                                                    actions: [
                                                                        .init(
                                                                            "View",
                                                                            href:
                                                                                AccountAdminRoutes
                                                                                .invitationDetails(
                                                                                    RouterPath(
                                                                                        invitation
                                                                                            .id
                                                                                    )
                                                                                )
                                                                                .description,
                                                                            style:
                                                                                .ghost(
                                                                                    .primary
                                                                                ),
                                                                            permission:
                                                                                AccountPermissions
                                                                                .Invitations
                                                                                .read
                                                                        ),
                                                                        .init(
                                                                            "Edit",
                                                                            href:
                                                                                AccountAdminRoutes
                                                                                .invitationEdit(
                                                                                    RouterPath(
                                                                                        invitation
                                                                                            .id
                                                                                    )
                                                                                )
                                                                                .description,
                                                                            style:
                                                                                .ghost(
                                                                                    .secondary
                                                                                ),
                                                                            permission:
                                                                                AccountPermissions
                                                                                .Invitations
                                                                                .update
                                                                        ),
                                                                    ],
                                                                    permissions:
                                                                        state
                                                                        .permissions
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
                                    action: AccountAdminRoutes.invitations
                                        .description,
                                    placeholder: "Quick search invitations",
                                    search: state.search
                                )
                            )
                        )
                    },
                    toolbar: {
                        if state.permissions.allows(
                            AccountPermissions.Invitations.create
                        ) {
                            context.build(
                                AdminListToolbar {
                                    context.build(
                                        AdminButton(
                                            "Add new",
                                            href: AccountAdminRoutes
                                                .invitationAdd.description
                                        )
                                    )
                                }
                            )
                        }
                    },
                    pagination: {
                        context.build(
                            AdminListPagination(
                                state: .init(
                                    path: AccountAdminRoutes.invitations
                                        .description,
                                    pageState: state.pageState,
                                    search: state.search
                                )
                            )
                        )
                    }
                )
            )
        }
        .class("cms-section")
    }
}
