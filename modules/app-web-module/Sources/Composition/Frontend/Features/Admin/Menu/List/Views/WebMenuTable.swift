import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebContracts

struct WebMenuTable: Component {
    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let rules: [Components.Schemas.WebMenuListItemSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let deniedInfo: String
        let deniedMessage: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    private var pageState: NewAdminListPageState {
        .init(page: state.page, pageSize: state.pageSize, total: state.total)
    }

    private var actions: NewAdminListActions {
        NewAdminListActions(
            Set(
                WebPermissions.Menus.allPermissions().filter {
                    state.permissions.contains($0.rawValue)
                }
            )
        )
    }

    private var returnTo: String {
        NewAdminLocation.url(
            path: WebMenuRoutes.list.description,
            page: state.page,
            search: state.search
        )
    }

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Menus",
                        description: "Manage navigation menus for the public website."
                    )
                )
            )
            if !state.canAccess {
                context.render(
                    NewAdminStatusView(
                        state: .init(
                            title: state.deniedInfo,
                            message: state.deniedMessage
                        ),
                        icon: FeatherIcons.lock()
                    )
                )
            }
            else {
                if state.isAdded { P("Menu added successfully.") }
                if state.isEdited { P("Menu edited successfully.") }
                if state.isRemoved { P("Menu removed successfully.") }
                context.render(
                    NewAdminList(
                        table: {
                            if pageState.isPageOutOfRange {
                                context.render(
                                    NewAdminListInvalidPageState(
                                        pageState: pageState,
                                        path: WebMenuRoutes.list.description
                                    )
                                )
                            }
                            else if state.rules.isEmpty {
                                if state.search.isEmpty {
                                    context.render(
                                        NewAdminListEmptyState(
                                            message: "No menus yet.",
                                            icon: FeatherIcons.inbox(),
                                            action: {
                                                if state.canAdd {
                                                    context.render(
                                                        NewAdminButton(
                                                            "Add new",
                                                            href: WebMenuRoutes.add.description
                                                        )
                                                    )
                                                }
                                            }
                                        )
                                    )
                                }
                                else {
                                    context.render(
                                        NewAdminListNoResultsState(
                                            message: "No menus match your search.",
                                            icon: FeatherIcons.inbox(),
                                            action: {
                                                context.render(
                                                    NewAdminButton(
                                                        "Reset search",
                                                        href: WebMenuRoutes.list.description,
                                                        style: .secondary
                                                    )
                                                )
                                            }
                                        )
                                    )
                                }
                            }
                            else {
                                let canDelete = actions.allows(WebPermissions.Menus.delete)
                                context.render(
                                    NewAdminListSelectionForm(
                                        state: .init(
                                            action: WebMenuRoutes.remove.description,
                                            pageState: pageState,
                                            search: state.search,
                                            button: .init(
                                                "Remove selected",
                                                style: .destructive
                                            ),
                                            isEnabled: canDelete
                                        ),
                                        table: context.render(
                                            NewAdminListShell(
                                                layout: .init(
                                                    name: "web-menus",
                                                    columns: [
                                                        .fraction(1),
                                                        .fraction(2),
                                                        .fixed(220),
                                                    ]
                                                ),
                                                hasSelection: canDelete,
                                                table: Table {
                                                    Thead {
                                                        Tr {
                                                            if canDelete {
                                                                context.render(NewAdminListSelectAllCheckbox())
                                                            }
                                                            Th("Key")
                                                            Th("Name")
                                                            Th("Actions")
                                                        }
                                                    }
                                                    Tbody {
                                                        for rule in state.rules {
                                                            Tr {
                                                                if canDelete {
                                                                    context.render(NewAdminListRowCheckbox(id: rule.id))
                                                                }
                                                                Td(rule.key).data("label", "Key")
                                                                Td(rule.name).data("label", "Name")
                                                                context.render(
                                                                    NewAdminListRowActions(
                                                                        label: "Actions",
                                                                        actions: [
                                                                            .init("View", href: WebMenuRoutes.details(RouterPath(rule.id)).description, style: .ghost(.primary), permission: WebPermissions.Menus.read),
                                                                            .init("Edit", href: WebMenuRoutes.edit(RouterPath(rule.id)).description, style: .ghost(.secondary), permission: WebPermissions.Menus.update),
                                                                            .init("Remove", href: WebMenuRoutes.details(RouterPath(rule.id)).appendingPath(RouterPath("remove")).description, style: .destructive, permission: WebPermissions.Menus.delete),
                                                                        ],
                                                                        permissions: actions
                                                                    )
                                                                )
                                                            }
                                                        }
                                                    }
                                                }
                                                .class("cms-table", "action-table")
                                                .if(canDelete) { $0.class("select-table") }
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
                                        action: WebMenuRoutes.list.description,
                                        placeholder: "Quick search menus",
                                        search: state.search
                                    )
                                )
                            )
                        },
                        toolbar: {
                            if state.canAdd {
                                context.render(
                                    NewAdminListToolbar {
                                        context.render(
                                            NewAdminButton(
                                                "Add new",
                                                href: WebMenuRoutes.add.description
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
                                        path: WebMenuRoutes.list.description,
                                        pageState: pageState,
                                        search: state.search
                                    )
                                )
                            )
                        }
                    )
                )
            }
        }
        .class("cms-section")
    }
}
