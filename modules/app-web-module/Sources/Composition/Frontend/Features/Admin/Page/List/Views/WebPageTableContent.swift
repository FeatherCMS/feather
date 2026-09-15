import CSS
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct WebPageTableContent: Component {
    let pages: [AdminListWebPageItemModel]
    let permissions: NewAdminListActions
    let pageState: NewAdminListPageState
    let search: String?

    private var searchValue: String { search ?? "" }
    private var returnTo: String {
        NewAdminLocation.url(
            path: WebPageRoutes.list.description,
            page: pageState.page,
            search: search
        )
    }

    func selectors() -> [any CSS.Selector] {
        [Class("web-page-status-forms") { Display(.none) }]
    }

    func html(context: inout RenderContext) -> Div {
        let canDelete = permissions.allows(WebPermissions.Pages.delete)
        let canEdit = permissions.allows(WebPermissions.Pages.update)
        let hasActiveQuery = !searchValue.isEmpty

        return Div {
            if canEdit { statusFormDefinitions(context: &context) }
            context.render(
                NewAdminList(
                    table: {
                        if pageState.isPageOutOfRange {
                            context.render(
                                NewAdminListInvalidPageState(
                                    pageState: pageState,
                                    path: WebPageRoutes.list.description
                                )
                            )
                        }
                        else if pages.isEmpty {
                            if hasActiveQuery {
                                context.render(
                                    NewAdminListNoResultsState(
                                        message:
                                            "No web pages match your search.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            context.render(
                                                NewAdminButton(
                                                    "Reset search",
                                                    href: WebPageRoutes.list
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
                                        message: "No web pages yet.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            if permissions.allows(
                                                WebPermissions.Pages.create
                                            ) {
                                                context.render(
                                                    NewAdminButton(
                                                        "Add new",
                                                        href: WebPageRoutes.add
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
                            context.render(
                                NewAdminListSelectionForm(
                                    state: .init(
                                        action: WebPageRoutes.remove
                                            .description,
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
                                            layout: .init(
                                                name: "web-pages",
                                                columns: [
                                                    .fraction(2), .fixed(140),
                                                    .fixed(180), .fixed(250),
                                                ]
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
                                                        Th("Title")
                                                        Th("Status")
                                                        Th("Publication")
                                                        Th("Actions")
                                                    }
                                                }
                                                Tbody {
                                                    for page in pages {
                                                        context.render(
                                                            WebPageRow(
                                                                page: page,
                                                                permissions:
                                                                    permissions,
                                                                canEdit:
                                                                    canEdit,
                                                                returnTo:
                                                                    returnTo
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
                                    action: WebPageRoutes.list.description,
                                    placeholder: "Quick search web pages",
                                    search: searchValue
                                )
                            )
                        )
                    },
                    toolbar: {
                        if permissions.allows(WebPermissions.Pages.create) {
                            context.render(
                                NewAdminListToolbar {
                                    context.render(
                                        NewAdminButton(
                                            "Add new",
                                            href: WebPageRoutes.add.description
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
                                    path: WebPageRoutes.list.description,
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

    private func statusFormDefinitions(context: inout RenderContext)
        -> some FlowContent
    {
        Div {
            for page in pages {
                context.render(
                    NewAdminStatusSelectFormDefinition(
                        id: statusFormID(for: page.id),
                        action: WebPageRoutes.status(RouterPath(page.id))
                            .description,
                        returnTo: WebPageRoutes.list.description
                    )
                )
            }
        }
        .class("web-page-status-forms")
    }

    private func statusFormID(for id: String) -> String {
        "web-page-status-\(id)"
    }
}
