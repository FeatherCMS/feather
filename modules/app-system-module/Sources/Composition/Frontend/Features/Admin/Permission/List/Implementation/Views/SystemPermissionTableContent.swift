import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import SystemContracts
import WebBuilders
import WebComponents

struct SystemPermissionTableContent: Component {
    let permissions: [Components.Schemas.SystemPermissionListItemSchema]
    let actions: NewAdminListActions
    let pageState: NewAdminListPageState
    let search: String?

    private var searchValue: String {
        search ?? ""
    }

    private var returnTo: String {
        NewAdminLocation.url(
            path: SystemPermissionRoutes.list.description,
            page: pageState.page,
            search: search
        )
    }

    func html(context: inout RenderContext) -> Div {
        let canDelete = actions.allows(SystemPermissions.Permissions.delete)
        let hasActiveQuery = !(search?.isEmpty ?? true)

        return context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: SystemPermissionRoutes.list.description
                            )
                        )
                    }
                    else if permissions.isEmpty {
                        if hasActiveQuery {
                            context.render(
                                NewAdminListNoResultsState(
                                    message:
                                        "No system permissions match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.render(
                                            NewAdminButton(
                                                "Reset search",
                                                href: SystemPermissionRoutes
                                                    .list
                                                    .description,
                                                style: .secondary
                                            )
                                        )
                                    }
                                )
                            )
                        }
                        else {
                            context.render(
                                NewAdminListEmptyState(
                                    message: "No system permissions yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if actions.allows(
                                            SystemPermissions.Permissions.create
                                        ) {
                                            context.render(
                                                NewAdminButton(
                                                    "Add new",
                                                    href: SystemPermissionRoutes
                                                        .add.description
                                                )
                                            )
                                        }
                                    }
                                )
                            )
                        }
                    }
                    else {
                        context.render(
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: NewAdminLocation.remove(
                                        path: SystemPermissionRoutes.remove
                                            .description,
                                        ids: [],
                                        returnTo: returnTo
                                    ),
                                    pageState: pageState,
                                    search: searchValue,
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
                                                    Th("Key")
                                                        .columnWidth(
                                                            percent: 50
                                                        )
                                                    Th("Name")
                                                        .columnWidth(
                                                            percent: 50
                                                        )
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for permission in permissions {
                                                    context.render(
                                                        SystemPermissionRow(
                                                            permission:
                                                                permission,
                                                            actions: actions,
                                                            returnTo: returnTo
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
                                action: SystemPermissionRoutes.list.description,
                                placeholder: "Quick search system permissions",
                                search: searchValue
                            )
                        )
                    )
                },
                toolbar: {
                    if actions.allows(SystemPermissions.Permissions.create) {
                        context.render(
                            NewAdminListToolbar {
                                context.render(
                                    NewAdminButton(
                                        "Add new",
                                        href: SystemPermissionRoutes.add
                                            .description
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
                                path: SystemPermissionRoutes.list.description,
                                pageState: pageState,
                                search: searchValue
                            )
                        )
                    )
                }
            )
        )
    }
}
