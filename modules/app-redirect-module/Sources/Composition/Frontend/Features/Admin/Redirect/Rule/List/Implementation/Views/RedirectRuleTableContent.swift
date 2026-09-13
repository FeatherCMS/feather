import FeatherAdmin
import HTML
import Hummingbird
import RedirectAdminAPI
import RedirectContracts
import SGML
import WebBuilders
import WebComponents

struct RedirectRuleTableContent: Component {
    let state: RedirectRuleTable.State

    private var searchValue: String { state.search ?? "" }

    private var isFiltered: Bool {
        !searchValue.isEmpty || !(state.statusCode?.isEmpty ?? true)
    }

    private var returnTo: String {
        NewAdminLocation.url(
            path: RedirectRuleRoutes.list.description,
            page: state.pageState.page,
            search: state.search,
            queryItems: state.statusCode.map { [("statusCode", $0)] } ?? []
        )
    }

    func html(context: inout RenderContext) -> Div {
        let canDelete = state.permissions.allows(
            RedirectPermissions.Rules.delete
        )

        return context.render(
            NewAdminList(
                table: {
                    if state.pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: state.pageState,
                                path: RedirectRuleRoutes.list.description
                            )
                        )
                    }
                    else if state.rules.isEmpty {
                        context.render(
                            NewAdminListEmptyState(
                                resourceName: "redirect rules",
                                isFiltered: isFiltered,
                                filteredMessage:
                                    "No redirect rules match your search or filters.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if isFiltered {
                                        context.render(
                                            NewAdminButton(
                                                "Reset search",
                                                href: RedirectRuleRoutes.list
                                                    .description,
                                                style: .secondary
                                            )
                                        )
                                    }
                                    else if state.permissions.allows(
                                        RedirectPermissions.Rules.create
                                    ) {
                                        context.render(
                                            NewAdminButton(
                                                "Add rule",
                                                href: RedirectRuleRoutes.add
                                                    .description
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
                                    action: NewAdminLocation.remove(
                                        path: RedirectRuleRoutes.remove
                                            .description,
                                        ids: [],
                                        returnTo: returnTo
                                    ),
                                    pageState: state.pageState,
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
                                                    Th("Source")
                                                        .columnWidth(
                                                            percent: 22
                                                        )
                                                    Th("Destination")
                                                        .columnWidth(
                                                            percent: 40
                                                        )
                                                    Th("Status")
                                                        .columnWidth(
                                                            percent: 10
                                                        )
                                                    Th("Actions")
                                                        .columnWidth(
                                                            percent: 28
                                                        )
                                                }
                                            }
                                            Tbody {
                                                for rule in state.rules {
                                                    context.render(
                                                        RedirectRuleRow(
                                                            rule: rule,
                                                            returnTo: returnTo,
                                                            permissions: state
                                                                .permissions
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
                                action: RedirectRuleRoutes.list.description,
                                placeholder: "Quick search redirect rules",
                                search: searchValue
                            ),
                            additionalFields: {
                                Select {
                                    Option("All statuses")
                                        .value("")
                                        .if(state.statusCode?.isEmpty ?? true) {
                                            $0.selected()
                                        }
                                    Option("301 Moved Permanently")
                                        .value("301")
                                        .if(state.statusCode == "301") {
                                            $0.selected()
                                        }
                                    Option("302 Found")
                                        .value("302")
                                        .if(state.statusCode == "302") {
                                            $0.selected()
                                        }
                                    Option("307 Temporary Redirect")
                                        .value("307")
                                        .if(state.statusCode == "307") {
                                            $0.selected()
                                        }
                                    Option("308 Permanent Redirect")
                                        .value("308")
                                        .if(state.statusCode == "308") {
                                            $0.selected()
                                        }
                                }
                                .name("statusCode")
                            }
                        )
                    )
                },
                toolbar: {
                    if state.permissions.allows(
                        RedirectPermissions.Rules.create
                    ) {
                        context.render(
                            NewAdminListToolbar {
                                context.render(
                                    NewAdminButton(
                                        "Add rule",
                                        href: RedirectRuleRoutes.add.description
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
                                path: RedirectRuleRoutes.list.description,
                                pageState: state.pageState,
                                search: searchValue,
                                queryItems: state.statusCode.map {
                                    [.init(name: "statusCode", value: $0)]
                                } ?? []
                            )
                        )
                    )
                }
            )
        )
    }
}
