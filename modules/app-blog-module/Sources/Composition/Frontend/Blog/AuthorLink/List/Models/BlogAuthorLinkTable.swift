import BlogAdminAPI
import BlogContracts
import FeatherAdmin
import FeatherModuleKit
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
        let pageState: AdminListPageState
        let search: String
        let permissions: AdminListActions
        let breadcrumb: [AdminBreadcrumb.Link]
        let error: String?
    }
    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            if !state.canAccess {
                context.build(
                    AdminStatusView(
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
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Blog author links",
                            description: "Manage links shown for this author."
                        )
                    )
                )
                if let error = state.error {
                    P(error).class("admin-form__error")
                }
                context.build(BlogAuthorLinkTableContent(state: state))
            }
        }
        .class("cms-section")
    }
}

struct BlogAuthorLinkTableContent: Component {
    let state: BlogAuthorLinkTable.State
    func html(context: inout BuilderContext) -> Div {
        let canDelete = state.permissions.allows(
            BlogPermissions.AuthorLinks.delete
        )
        let links = BlogAdminRoutes.authorLinks(RouterPath(state.authorId))
        return context.build(
            AdminList(
                table: {
                    if state.items.isEmpty {
                        context.build(
                            AdminListNoResultsState(
                                message: state.search.isEmpty
                                    ? "No blog author links yet."
                                    : "No blog author links match your search."
                            )
                        )
                    }
                    else {
                        context.build(
                            AdminListSelectionForm(
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
                                table: context.build(
                                    AdminListShell(
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
                                                        context.build(
                                                            AdminListSelectAllCheckbox()
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
                                                            context.build(
                                                                AdminListRowCheckbox(
                                                                    id: item.id
                                                                )
                                                            )
                                                        }
                                                        Td(item.label)
                                                            .data(
                                                                "label",
                                                                "Label"
                                                            )
                                                            .data(
                                                                "remove-label",
                                                                "true"
                                                            )
                                                        Td(item.url)
                                                            .data(
                                                                "label",
                                                                "URL"
                                                            )
                                                        Td("\(item.priority)")
                                                            .data(
                                                                "label",
                                                                "Priority"
                                                            )
                                                        Td {
                                                            context.build(
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
                                                        context.build(
                                                            AdminListRowActions(
                                                                label:
                                                                    "Actions",
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
                                                                ],
                                                                permissions:
                                                                    state
                                                                    .permissions
                                                            )
                                                        )
                                                    }
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
                                action: links.description,
                                placeholder: "Search author links",
                                search: state.search
                            )
                        )
                    )
                },
                toolbar: {
                    if state.canAdd {
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
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
                    context.build(
                        AdminListPagination(
                            state: .init(
                                path: links.description,
                                pageState: state.pageState,
                                search: state.search
                            )
                        )
                    )
                }
            )
        )
    }

    private func blankChip(_ value: Bool) -> AdminChip {
        .init(label: value ? "Yes" : "No", color: value ? .blue : .purple)
    }
}
