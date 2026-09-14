import AccountAdminAPI
import AccountContracts
import FeatherAdmin
import FeatherContracts
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
        let permissions: NewAdminListActions
        let invitations: [Components.Schemas.AccountInvitationListItemSchema]
        let pageState: NewAdminListPageState
        let search: String
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        let canDelete = state.permissions.allows(AccountPermissions.Invitations.delete)

        return Div {
            context.render(NewAdminBreadcrumb(links: AccountAdminRoutes.invitationBreadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "User invitations",
                        description: "Manage invitations sent to prospective users."
                    )
                )
            )
            context.render(
                NewAdminList(
                table: {
                    if !state.canAccess {
                        context.render(
                            NewAdminStatusView(
                                state: .init(
                                    title: "Forbidden",
                                    message: "Your identity cannot access user invitations."
                                ),
                                icon: FeatherIcons.alertCircle()
                            )
                        )
                    }
                    else if state.pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: state.pageState,
                                path: AccountAdminRoutes.invitations.description
                            )
                        )
                    }
                    else if state.invitations.isEmpty {
                        context.render(
                            NewAdminListEmptyState(
                                message: state.search.isEmpty
                                    ? "No user invitations yet."
                                    : "No invitations match your search.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if !state.search.isEmpty {
                                        context.render(
                                            NewAdminButton(
                                                "Reset search",
                                                href: AccountAdminRoutes.invitations.description,
                                                style: .secondary
                                            )
                                        )
                                    }
                                    else if state.permissions.allows(AccountPermissions.Invitations.create) {
                                        context.render(
                                            NewAdminButton(
                                                "Add new",
                                                href: AccountAdminRoutes.invitationAdd.description
                                            )
                                        )
                                    }
                                }
                            )
                        )
                    }
                    else {
                        context.render(
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: AccountAdminRoutes.invitationRemoveBulk.description,
                                    pageState: state.pageState,
                                    search: state.search,
                                    button: .init("Remove selected", style: .destructive),
                                    isEnabled: canDelete
                                ),
                                table: context.render(
                                    NewAdminListShell(
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
                                                        context.render(NewAdminListSelectAllCheckbox())
                                                    }
                                                    Th("Email")
                                                    Th("Expires at")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for invitation in state.invitations {
                                                    Tr {
                                                        if canDelete {
                                                            context.render(NewAdminListRowCheckbox(id: invitation.id))
                                                        }
                                                        Td(invitation.email).data("label", "Email")
                                                        Td(DateFormatting.formatUnixTimestamp(invitation.expiresAt))
                                                            .data("label", "Expires at")
                                                        context.render(
                                                            NewAdminListRowActions(
                                                                label: "Actions",
                                                                actions: [
                                                                    .init("View", href: AccountAdminRoutes.invitationDetails(RouterPath(invitation.id)).description, style: .ghost(.primary), permission: AccountPermissions.Invitations.read),
                                                                    .init("Edit", href: AccountAdminRoutes.invitationEdit(RouterPath(invitation.id)).description, style: .ghost(.secondary), permission: AccountPermissions.Invitations.update),
                                                                    .init("Remove", href: AccountAdminRoutes.invitationRemove(RouterPath(invitation.id)).description, style: .destructive, permission: AccountPermissions.Invitations.delete),
                                                                ],
                                                                permissions: state.permissions
                                                            )
                                                        )
                                                    }
                                                }
                                            }
                                        }
                                        .class("cms-table", "action-table")
                                        .if(canDelete) { $0.class("select-table") }
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
                                action: AccountAdminRoutes.invitations.description,
                                placeholder: "Quick search invitations",
                                search: state.search
                            )
                        )
                    )
                },
                toolbar: {
                    if state.permissions.allows(AccountPermissions.Invitations.create) {
                        context.render(
                            NewAdminListToolbar {
                                context.render(
                                    NewAdminButton(
                                        "Add new",
                                        href: AccountAdminRoutes.invitationAdd.description
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
                                path: AccountAdminRoutes.invitations.description,
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
