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

    private var returnTo: String {
        NewAdminLocation.url(
            path: RedirectRuleRoutes.list.description,
            page: state.pageState.page,
            search: state.search,
            queryItems: state.statusCode.map { [("statusCode", $0)] } ?? []
        )
    }

    func html(context: inout RenderContext) -> Div {
        let canDelete = state.permissions.allows(RedirectPermissions.Rules.delete)

        return context.render(NewAdminList(
            table: {
                if state.pageState.isPageOutOfRange {
                    context.render(NewAdminListInvalidPageState(pageState: state.pageState, path: RedirectRuleRoutes.list.description))
                } else if state.rules.isEmpty {
                    context.render(NewAdminListEmptyState(
                        message: state.search?.isEmpty ?? true ? "No redirect rules yet." : "No redirect rules match your search.",
                        icon: FeatherIcons.inbox(),
                        action: {
                            if !(state.search?.isEmpty ?? true) {
                                context.render(NewAdminButton("Reset search", href: RedirectRuleRoutes.list.description, style: .secondary))
                            } else if state.permissions.allows(RedirectPermissions.Rules.create) {
                                context.render(NewAdminButton("Add rule", href: RedirectRuleRoutes.add.description))
                            }
                        }
                    ))
                } else {
                    context.render(NewAdminListSelectionForm(
                        state: .init(
                            action: NewAdminLocation.remove(path: RedirectRuleRoutes.remove.description, ids: [], returnTo: returnTo),
                            pageState: state.pageState,
                            search: searchValue,
                            button: .init("Remove selected", style: .destructive),
                            isEnabled: canDelete
                        ),
                        table: context.render(NewAdminListShell(
                            table: Table {
                                Thead {
                                    Tr {
                                        if canDelete { context.render(NewAdminListSelectAllCheckbox()) }
                                        Th("Source")
                                        Th("Destination")
                                        Th("Status")
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for rule in state.rules {
                                        context.render(RedirectRuleRow(rule: rule, returnTo: returnTo, permissions: state.permissions))
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canDelete) { $0.class("select-table") }
                        ))
                    ))
                }
            },
            search: { context.render(RedirectRuleSearch(search: searchValue, statusCode: state.statusCode ?? "")) },
            toolbar: {
                if state.permissions.allows(RedirectPermissions.Rules.create) {
                    context.render(NewAdminListToolbar { context.render(NewAdminButton("Add rule", href: RedirectRuleRoutes.add.description)) })
                }
            },
            pagination: {
                context.render(NewAdminListPagination(state: .init(
                    path: RedirectRuleRoutes.list.description,
                    pageState: state.pageState,
                    search: searchValue,
                    queryItems: state.statusCode.map { [.init(name: "statusCode", value: $0)] } ?? []
                )))
            }
        ))
    }
}

private struct RedirectRuleSearch: Component {
    let search: String
    let statusCode: String

    func html(context: inout RenderContext) -> Form {
        Form {
            Input().type(.search).name("search").value(search).placeholder("Quick search redirect rules")
            Select {
                Option("All statuses").value("").if(statusCode.isEmpty) { $0.selected() }
                Option("301 Moved Permanently").value("301").if(statusCode == "301") { $0.selected() }
                Option("302 Found").value("302").if(statusCode == "302") { $0.selected() }
                Option("307 Temporary Redirect").value("307").if(statusCode == "307") { $0.selected() }
                Option("308 Permanent Redirect").value("308").if(statusCode == "308") { $0.selected() }
            }.name("statusCode")
            Button("Search").type(.submit)
            A("Reset").href(RedirectRuleRoutes.list.description)
        }.method(.get).action(RedirectRuleRoutes.list.description).class("new-admin-list-search redirect-rule-search")
    }
}
