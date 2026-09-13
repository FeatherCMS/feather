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
    let permissions: NewAdminListActions
    let pageState: NewAdminListPageState
    let search: String?

    func html(context: inout RenderContext) -> Div {
        let isFiltered = !(search?.isEmpty ?? true)

        return context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: UserRoleRoutes.list.description
                            )
                        )
                    }
                    else if roles.isEmpty {
                        context.render(
                            NewAdminListEmptyState(
                                resourceName: "user roles",
                                isFiltered: isFiltered,
                                filteredMessage:
                                    "No user roles match your search.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if isFiltered {
                                        context.render(
                                            NewAdminButton(
                                                "Reset search",
                                                href: UserRoleRoutes.list
                                                    .description,
                                                style: .secondary
                                            )
                                        )
                                    }
                                    else if permissions.allows(
                                        UserPermissions.Roles.create
                                    ) {
                                        context.render(
                                            NewAdminButton(
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
                    else {
                        let canDelete = permissions.allows(
                            UserPermissions.Roles.delete
                        )
                        context.render(
                            NewAdminListSelectionForm(
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
                                table: context.render(
                                    NewAdminListShell(
                                        table: Table {
                                            Thead {
                                                Tr {
                                                    if canDelete {
                                                        context.render(
                                                            NewAdminListSelectAllCheckbox()
                                                        )
                                                    }
                                                    Th("Name")
                                                        .columnWidth(
                                                            percent: 69
                                                        )
                                                    Th("Actions")
                                                        .columnWidth(
                                                            percent: 30
                                                        )
                                                }
                                            }
                                            Tbody {
                                                for role in roles {
                                                    context.render(
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
                    context.render(
                        NewAdminListSearch(
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
                        context.render(
                            NewAdminListToolbar {
                                context.render(
                                    NewAdminButton(
                                        "Add new",
                                        href: UserRoleRoutes.add.description
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
