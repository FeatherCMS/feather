import FeatherAdmin
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import UserContracts
import WebBuilders
import WebComponents

struct UserRoleTableContent: Component {
    let roles: [Components.Schemas.UserRoleListItemSchema]
    let permissions: AdminListActions
    let pageState: AdminListPageState
    let search: String?

    func html(context: inout BuilderContext) -> Div {
        let hasActiveQuery = !(search?.isEmpty ?? true)

        return context.build(
            AdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            AdminListInvalidPageState(
                                pageState: pageState,
                                path: UserRoleRoutes.list.description
                            )
                        )
                    }
                    else if roles.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                AdminListNoResultsState(
                                    message: "No user roles match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            AdminButton(
                                                "Reset search",
                                                href: UserRoleRoutes.list
                                                    .description,
                                                style: .secondary
                                            )
                                        )
                                    }
                                )
                            )
                        }
                        else {
                            context.build(
                                AdminListEmptyState(
                                    message: "No user roles yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if permissions.allows(
                                            UserPermissions.Roles.create
                                        ) {
                                            context.build(
                                                AdminButton(
                                                    "Add new",
                                                    href: UserRoleRoutes.add
                                                        .description
                                                )
                                            )
                                        }
                                    }
                                )
                            )
                        }
                    }
                    else {
                        let canDelete = permissions.allows(
                            UserPermissions.Roles.delete
                        )
                        context.build(
                            AdminListSelectionForm(
                                state: .init(
                                    action: UserRoleRoutes.remove.description,
                                    pageState: pageState,
                                    search: search ?? "",
                                    button: .init(
                                        "Remove selected",
                                        style: .destructive
                                    ),
                                    isEnabled: canDelete
                                ),
                                table: context.build(
                                    AdminListShell(
                                        layout: .init(
                                            name: "user-roles",
                                            columns: [
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
                                                    Th("Name")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for role in roles {
                                                    context.build(
                                                        UserRoleRow(
                                                            role: role,
                                                            permissions:
                                                                permissions
                                                        )
                                                    )
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
                                action: UserRoleRoutes.list.description,
                                placeholder: "Quick search user roles",
                                search: search ?? ""
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(UserPermissions.Roles.create) {
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
                                        "Add new",
                                        href: UserRoleRoutes.add.description
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
                                path: UserRoleRoutes.list.description,
                                pageState: pageState,
                                search: search ?? ""
                            )
                        )
                    )
                }
            )
        )
    }
}
