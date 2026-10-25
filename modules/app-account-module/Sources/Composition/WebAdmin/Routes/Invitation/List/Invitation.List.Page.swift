import AccountAdminAPI
import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension Invitation.List {
    struct Page: Component {
        let routes: Invitation.Router.Routes
        struct State {
            let isAdded: Bool
            let isEdited: Bool
            let isRemoved: Bool
            let canAccess: Bool
            let permissions: AdminListActions
            let invitations: [Components.Schemas.InvitationQuerySchemasItem]
            let pageState: AdminListPageState
            let search: String
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            let canDelete = state.permissions.allows(
                Invitation.Permissions.delete
            )

            return Div {
                context.build(
                    AdminBreadcrumb(
                        links: routes
                            .invitationBreadcrumb
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
                                        path: routes
                                            .invitations
                                            .path
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
                                                        href: routes.invitations
                                                            .path,
                                                        style: .secondary
                                                    )
                                                )
                                            }
                                            else if state.permissions.allows(
                                                Invitation.Permissions.create
                                            ) {
                                                context.build(
                                                    AdminButton(
                                                        "Add new",
                                                        href: routes
                                                            .invitationAdd
                                                            .path
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
                                            action: routes.invitationRemoveBulk
                                                .path,
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
                                                                    context
                                                                        .build(
                                                                            AdminListRowCheckbox(
                                                                                id:
                                                                                    invitation
                                                                                    .id
                                                                            )
                                                                        )
                                                                }
                                                                Td(
                                                                    invitation
                                                                        .email
                                                                )
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
                                                                                    routes
                                                                                    .invitationDetailsPath(
                                                                                        invitation
                                                                                            .id
                                                                                    ),
                                                                                style:
                                                                                    .ghost(
                                                                                        .primary
                                                                                    ),
                                                                                permission:
                                                                                    Invitation
                                                                                    .Permissions
                                                                                    .read
                                                                            ),
                                                                            .init(
                                                                                "Edit",
                                                                                href:
                                                                                    routes
                                                                                    .invitationEditPath(
                                                                                        invitation
                                                                                            .id
                                                                                    ),
                                                                                style:
                                                                                    .ghost(
                                                                                        .secondary
                                                                                    ),
                                                                                permission:
                                                                                    Invitation
                                                                                    .Permissions
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
                                                .class(
                                                    "cms-table",
                                                    "action-table"
                                                )
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
                                        action: routes
                                            .invitations
                                            .path,
                                        placeholder: "Quick search invitations",
                                        search: state.search
                                    )
                                )
                            )
                        },
                        toolbar: {
                            if state.permissions.allows(
                                Invitation.Permissions.create
                            ) {
                                context.build(
                                    AdminListToolbar {
                                        context.build(
                                            AdminButton(
                                                "Add new",
                                                href: routes.invitationAdd.path
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
                                        path: routes
                                            .invitations
                                            .path,
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
}
