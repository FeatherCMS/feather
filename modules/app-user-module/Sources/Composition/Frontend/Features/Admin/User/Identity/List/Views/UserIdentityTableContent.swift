import FeatherAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import UserContracts
import WebBuilders
import WebComponents

struct UserIdentityTableContent: Component {
    let permissions: AdminListActions
    let identities: [Components.Schemas.UserIdentityListItemSchema]
    let pageState: AdminListPageState
    let search: String?
    let role: String?

    func html(context: inout BuilderContext) -> Div {
        let hasActiveQuery =
            !(search?.isEmpty ?? true) || !(role?.isEmpty ?? true)

        return context.build(
            AdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            AdminListInvalidPageState(
                                pageState: pageState,
                                path: UserIdentityRoutes.list.description
                            )
                        )
                    }
                    else if identities.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                AdminListNoResultsState(
                                    message:
                                        "No user identities match your search or filters.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            AdminButton(
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
                            context.build(
                                AdminListEmptyState(
                                    message: "No user identities yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if permissions.allows(
                                            UserPermissions.Identities.create
                                        ) {
                                            context.build(
                                                AdminButton(
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
                        context.build(
                            AdminListSelectionForm(
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
                                table: context.build(
                                    AdminListShell(
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
                                                        context.build(
                                                            AdminListSelectAllCheckbox()
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
                                                    context.build(
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
                    context.build(
                        AdminListSearch(
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
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
                                        "Add new",
                                        href: UserIdentityRoutes.add.description
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
