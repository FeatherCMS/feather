import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import UserContracts
import WebBuilders
import WebComponents

struct UserIdentityTableContent: Component {
    let permissions: NewAdminListActions
    let identities: [Components.Schemas.UserIdentityListItemSchema]
    let pageState: NewAdminListPageState
    let search: String?
    let role: String?

    func html(context: inout RenderContext) -> Div {
        let hasActiveQuery =
            !(search?.isEmpty ?? true) || !(role?.isEmpty ?? true)

        return context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: UserIdentityRoutes.list.description
                            )
                        )
                    }
                    else if identities.isEmpty {
                        if hasActiveQuery {
                            context.render(
                                NewAdminListNoResultsState(
                                    message:
                                        "No user identities match your search or filters.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.render(
                                            NewAdminButton(
                                                "Reset filters",
                                                href: UserIdentityRoutes.list
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
                                    message: "No user identities yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if permissions.allows(
                                            UserPermissions.Identities.create
                                        ) {
                                            context.render(
                                                NewAdminButton(
                                                    "Add new",
                                                    href: UserIdentityRoutes.add
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
                            UserPermissions.Identities.delete
                        )
                        context.render(
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: UserIdentityRoutes.remove
                                        .description,
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
                                        layout: .init(
                                            name: "user-identities",
                                            columns: [
                                                .fixed(260),
                                                .fixed(220),
                                                .fixed(120),
                                                .fraction(1),
                                                .fixed(220),
                                            ],
                                            minimumWidth: 1000
                                        ),
                                        hasSelection: canDelete,
                                        table: Table {
                                            Thead {
                                                Tr {
                                                    if canDelete {
                                                        context.render(
                                                            NewAdminListSelectAllCheckbox()
                                                        )
                                                    }
                                                    Th("ID")
                                                    Th("Name")
                                                    Th("Status")
                                                    Th("Roles")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for identity in identities {
                                                    context.render(
                                                        UserIdentityRow(
                                                            identity: identity,
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
                                action: UserIdentityRoutes.list.description,
                                placeholder: "Quick search user identities",
                                search: search ?? ""
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(UserPermissions.Identities.create) {
                        context.render(
                            NewAdminListToolbar {
                                context.render(
                                    NewAdminButton(
                                        "Add new",
                                        href: UserIdentityRoutes.add.description
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
                                path: UserIdentityRoutes.list.description,
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
