import BlogAdminAPI
import BlogContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct BlogAuthorLinkTable: Component {
    struct State {
        let authorId: String
        let canAccess: Bool
        let canAdd: Bool
        let items:
            [BlogAdminAPI.Components.Schemas.BlogAuthorLinkListItemSchema]
        let pageState: NewAdminListPageState
        let search: String
        let permissions: NewAdminListActions
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let error: String?
    }
    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            if !state.canAccess {
                context.render(
                    NewAdminStatusView(
                        state: .init(
                            title: "Forbidden",
                            message:
                                "Your account cannot access blog author links."
                        ),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
            else {
                context.render(
                    NewAdminPageHeader(
                        state: .init(
                            title: "Blog author links",
                            description: "Manage links shown for this author."
                        )
                    )
                )
                if let error = state.error {
                    P(error).class("new-admin-form__error")
                }
                context.render(BlogAuthorLinkTableContent(state: state))
            }
        }
        .class("cms-section")
    }
}

struct BlogAuthorLinkTableContent: Component {
    let state: BlogAuthorLinkTable.State
    func html(context: inout RenderContext) -> Div {
        let canDelete = state.permissions.allows(
            BlogPermissions.AuthorLinks.delete
        )
        let links = BlogAdminRoutes.authorLinks(RouterPath(state.authorId))
        return NewAdminList(
            table: {
                if state.items.isEmpty {
                    context.render(
                        NewAdminListNoResultsState(
                            message: state.search.isEmpty
                                ? "No blog author links yet."
                                : "No blog author links match your search."
                        )
                    )
                }
                else {
                    context.render(
                        NewAdminListSelectionForm(
                            state: .init(
                                action:
                                    BlogAdminRoutes.authorLinkRemove(
                                        RouterPath(state.authorId)
                                    )
                                    .description,
                                pageState: state.pageState,
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
                                        name: "blog-author-links",
                                        columns: [
                                            .fraction(2), .fraction(2),
                                            .fixed(100), .fixed(110),
                                            .fraction(1), .fixed(220),
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
                                                Th("Label")
                                                Th("URL")
                                                Th("Priority")
                                                Th("Blank")
                                                Th("Permission")
                                                Th("Actions")
                                            }
                                        }
                                        Tbody {
                                            for item in state.items {
                                                Tr {
                                                    if canDelete {
                                                        context.render(
                                                            NewAdminListRowCheckbox(
                                                                id: item.id
                                                            )
                                                        )
                                                    }
                                                    Td(item.label)
                                                        .data("label", "Label")
                                                    Td(item.url)
                                                        .data("label", "URL")
                                                    Td("\(item.priority)")
                                                        .data(
                                                            "label",
                                                            "Priority"
                                                        )
                                                    Td {
                                                        context.render(
                                                            blankChip(
                                                                item.isBlank
                                                            )
                                                        )
                                                    }
                                                    .data("label", "Blank")
                                                    Td(item.permission)
                                                        .data(
                                                            "label",
                                                            "Permission"
                                                        )
                                                    context.render(
                                                        NewAdminListRowActions(
                                                            label: "Actions",
                                                            actions: [
                                                                .init(
                                                                    "Details",
                                                                    href:
                                                                        BlogAdminRoutes
                                                                        .authorLink(
                                                                            RouterPath(
                                                                                state
                                                                                    .authorId
                                                                            ),
                                                                            RouterPath(
                                                                                item
                                                                                    .id
                                                                            )
                                                                        )
                                                                        .description,
                                                                    permission:
                                                                        BlogPermissions
                                                                        .AuthorLinks
                                                                        .read
                                                                ),
                                                                .init(
                                                                    "Edit",
                                                                    href:
                                                                        BlogAdminRoutes
                                                                        .authorLinkEdit(
                                                                            RouterPath(
                                                                                state
                                                                                    .authorId
                                                                            ),
                                                                            RouterPath(
                                                                                item
                                                                                    .id
                                                                            )
                                                                        )
                                                                        .description,
                                                                    style:
                                                                        .ghost(
                                                                            .secondary
                                                                        ),
                                                                    permission:
                                                                        BlogPermissions
                                                                        .AuthorLinks
                                                                        .update
                                                                ),
                                                                .init(
                                                                    "Remove",
                                                                    href:
                                                                        NewAdminLocation
                                                                        .remove(
                                                                            path:
                                                                                BlogAdminRoutes
                                                                                .authorLinkRemove(
                                                                                    RouterPath(
                                                                                        state
                                                                                            .authorId
                                                                                    )
                                                                                )
                                                                                .description,
                                                                            ids: [
                                                                                item
                                                                                    .id
                                                                            ],
                                                                            returnTo:
                                                                                links
                                                                                .description
                                                                        ),
                                                                    style:
                                                                        .destructive,
                                                                    permission:
                                                                        BlogPermissions
                                                                        .AuthorLinks
                                                                        .delete
                                                                ),
                                                            ],
                                                            permissions: state
                                                                .permissions
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
                            action: links.description,
                            placeholder: "Search author links",
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
                                    "Add link",
                                    href:
                                        BlogAdminRoutes.authorLinkAdd(
                                            RouterPath(state.authorId)
                                        )
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
                            path: links.description,
                            pageState: state.pageState,
                            search: state.search
                        )
                    )
                )
            }
        )
        .html(context: &context)
    }

    private func blankChip(_ value: Bool) -> NewAdminChip {
        .init(label: value ? "Yes" : "No", color: value ? .blue : .purple)
    }
}
