import CSS
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents
import WebModule

extension Page.Search.Table {
    struct Content: Component {
        let pages: [Page.Search.Item]
        let permissions: AdminListActions
        let pageState: AdminListPageState
        let search: String?
        let routes: Page.Router.Routes

        private var searchValue: String { search ?? "" }
        private var returnTo: String {
            AdminLocation.url(
                path: routes.list.path,
                page: pageState.page,
                search: search
            )
        }

        func selectors() -> [any CSS.Selector] {
            [Class("web-page-status-forms") { Display(.none) }]
        }

        func html(context: inout BuilderContext) -> Div {
            let canDelete = permissions.allows(
                Page.Permissions.delete
            )
            let canEdit = permissions.allows(Page.Permissions.update)
            let hasActiveQuery = !searchValue.isEmpty

            return Div {
                if canEdit { statusFormDefinitions(context: &context) }
                context.build(
                    AdminList(
                        table: {
                            if pageState.isPageOutOfRange {
                                context.build(
                                    AdminListInvalidPageState(
                                        pageState: pageState,
                                        path: routes.list.path
                                    )
                                )
                            }
                            else if pages.isEmpty {
                                if hasActiveQuery {
                                    context.build(
                                        AdminListNoResultsState(
                                            message:
                                                "No web pages match your search.",
                                            icon: FeatherIcons.inbox(),
                                            action: {
                                                context.build(
                                                    AdminButton(
                                                        "Reset search",
                                                        href: routes.list.path,
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
                                            message: "No web pages yet.",
                                            icon: FeatherIcons.inbox(),
                                            action: {
                                                if permissions.allows(
                                                    Page.Permissions
                                                        .create
                                                ) {
                                                    context.build(
                                                        AdminButton(
                                                            "Add new",
                                                            href: routes.add
                                                                .path
                                                        )
                                                    )
                                                }
                                            }
                                        )
                                    )
                                }
                            }
                            else {
                                context.build(
                                    AdminListSelectionForm(
                                        state: .init(
                                            action: routes.remove.path,
                                            pageState: pageState,
                                            search: searchValue,
                                            button: .init(
                                                "Remove selected",
                                                style: .destructive
                                            ),
                                            isEnabled: canDelete
                                        ),
                                        table: context.build(
                                            AdminListShell(
                                                layout: .init(
                                                    name: "web-pages",
                                                    columns: [
                                                        .fraction(2),
                                                        .fixed(140),
                                                        .fixed(180),
                                                        .fixed(120),
                                                        .fixed(250),
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
                                                            Th("Title")
                                                            Th("Status")
                                                            Th("Publication")
                                                            Th("Availability")
                                                            Th("Actions")
                                                        }
                                                    }
                                                    Tbody {
                                                        for page in pages {
                                                            context.build(
                                                                Row(
                                                                    page: page,
                                                                    permissions:
                                                                        permissions,
                                                                    canEdit:
                                                                        canEdit,
                                                                    returnTo:
                                                                        returnTo,
                                                                    routes:
                                                                        routes
                                                                )
                                                            )
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
                                        action: routes.list.path,
                                        placeholder: "Quick search web pages",
                                        search: searchValue
                                    )
                                )
                            )
                        },
                        toolbar: {
                            if permissions.allows(
                                Page.Permissions.create
                            ) {
                                context.build(
                                    AdminListToolbar {
                                        context.build(
                                            AdminButton(
                                                "Add new",
                                                href: routes.add.path
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
                                        path: routes.list.path,
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

        private func statusFormDefinitions(context: inout BuilderContext)
            -> some FlowContent
        {
            Div {
                for page in pages {
                    context.build(
                        AdminStatusSelectFormDefinition(
                            id: statusFormID(for: page.id),
                            action: routes.statusPath(page.id),
                            returnTo: routes.list.path
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
}
