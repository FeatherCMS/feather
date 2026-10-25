import AuthAdminAPI
import AuthModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension Email.List {
    struct TableContent: WebComponents.Component {
        let state: Component.State

        func html(context: inout BuilderContext) -> Div {
            let actions = AdminListActions(
                Set(state.permissions.map(PermissionKey.init))
            )
            let pageState = AdminListPageState(
                page: state.page,
                pageSize: state.pageSize,
                total: state.total
            )

            return context.build(
                AdminList(
                    table: {
                        if !state.canAccess {
                            context.build(
                                AdminStatusView(
                                    state: .init(
                                        title: "Forbidden",
                                        message:
                                            "Your identity cannot access user emails."
                                    ),
                                    icon: FeatherIcons.alertCircle()
                                )
                            )
                        }
                        else if state.links.isEmpty {
                            context.build(
                                AdminListEmptyState(
                                    message: state.search.isEmpty
                                        ? "No user emails yet."
                                        : "No user emails match your search.",
                                    icon: FeatherIcons.inbox()
                                )
                            )
                        }
                        else {
                            let canDelete = actions.allows(
                                Email.Permissions.delete
                            )
                            let table = context.build(
                                AdminListShell(
                                    layout: .init(
                                        name: "auth-emails",
                                        columns: [
                                            .fraction(2),
                                            .fraction(2),
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
                                                Th("Identity")
                                                Th("Email")
                                                Th("Actions")
                                            }
                                        }
                                        Tbody {
                                            for email in state.links {
                                                Tr {
                                                    if canDelete {
                                                        context.build(
                                                            AdminListRowCheckbox(
                                                                id: email.id
                                                            )
                                                        )
                                                    }
                                                    Td(
                                                        state.identityNames[
                                                            email.identityId
                                                        ] ?? email.identityId
                                                    )
                                                    .data("label", "Identity")
                                                    Td(email.email)
                                                        .data("label", "Email")
                                                    context.build(
                                                        AdminListRowActions(
                                                            label: "Actions",
                                                            actions: [
                                                                .init(
                                                                    "View",
                                                                    href:
                                                                        state
                                                                        .routes
                                                                        .detailsPath(
                                                                            email
                                                                                .id
                                                                        ),
                                                                    style:
                                                                        .ghost(
                                                                            .primary
                                                                        ),
                                                                    permission:
                                                                        Email
                                                                        .Permissions
                                                                        .read
                                                                ),
                                                                .init(
                                                                    "Edit",
                                                                    href:
                                                                        state
                                                                        .routes
                                                                        .editPath(
                                                                            email
                                                                                .id
                                                                        ),
                                                                    style:
                                                                        .ghost(
                                                                            .secondary
                                                                        ),
                                                                    permission:
                                                                        Email
                                                                        .Permissions
                                                                        .update
                                                                ),
                                                            ],
                                                            permissions: actions
                                                        )
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    .class("cms-table", "action-table")
                                )
                            )
                            if canDelete {
                                context.build(
                                    AdminListSelectionForm(
                                        state: .init(
                                            action: AdminLocation.url(
                                                path: state.routes.remove.path,
                                                queryItems: state.userID.map {
                                                    [
                                                        .init(
                                                            name: "userId",
                                                            value: $0
                                                        )
                                                    ]
                                                } ?? []
                                            ),
                                            pageState: pageState,
                                            search: state.search,
                                            button: .init(
                                                "Remove selected",
                                                style: .destructive
                                            )
                                        ),
                                        table: table
                                    )
                                )
                            }
                            else {
                                table
                            }
                        }
                    },
                    search: {
                        context.build(
                            AdminListSearch(
                                state: .init(
                                    action: state.routes.list.path,
                                    placeholder: "Quick search user emails",
                                    search: state.search,
                                    queryItems: state.userID.map {
                                        [.init(name: "userId", value: $0)]
                                    } ?? []
                                )
                            )
                        )
                    },
                    toolbar: {
                        if state.canAdd {
                            context.build(
                                AdminListToolbar {
                                    context.build(
                                        AdminButton(
                                            "Add new",
                                                href: state.routes.add.path
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
                                    path: state.routes.list.path,
                                    pageState: pageState,
                                    search: state.search,
                                    queryItems: state.userID.map {
                                        [.init(name: "userId", value: $0)]
                                    } ?? []
                                )
                            )
                        )
                    }
                )
            )
        }
    }
}
