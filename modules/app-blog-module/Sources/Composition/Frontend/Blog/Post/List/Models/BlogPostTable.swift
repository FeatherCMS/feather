import BlogAdminAPI
import BlogAppAPI
import BlogContracts
import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct BlogPostTable: Component {
    struct State {
        let canAccess: Bool
        let canEdit: Bool
        let canAdd: Bool
        let items: [AdminListBlogPostItemModel]
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
                            message: "Your account cannot access blog posts."
                        ),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
            else {
                context.render(
                    NewAdminPageHeader(
                        state: .init(
                            title: "Blog posts",
                            description:
                                "Manage published content and publication status."
                        )
                    )
                )
                if let error = state.error {
                    P(error).class("new-admin-form__error")
                }
                context.render(BlogPostTableContent(state: state))
            }
        }
        .class("cms-section")
    }
}

private struct BlogPostTableContent: Component {
    let state: BlogPostTable.State

    func html(context: inout RenderContext) -> Div {
        let canDelete = state.permissions.allows(BlogPermissions.Posts.delete)
        return NewAdminList(
            table: {
                if state.items.isEmpty {
                    context.render(
                        NewAdminListNoResultsState(
                            message: state.search.isEmpty
                                ? "No blog posts yet."
                                : "No blog posts match your search."
                        )
                    )
                }
                else {
                    if state.canEdit {
                        for item in state.items {
                            context.render(
                                NewAdminStatusSelectFormDefinition(
                                    id: statusFormID(item.id),
                                    action:
                                        BlogAdminRoutes.postStatus(
                                            RouterPath(item.id)
                                        )
                                        .description,
                                    returnTo: BlogAdminRoutes.posts.description
                                )
                            )
                        }
                    }
                    context.render(
                        NewAdminListSelectionForm(
                            state: .init(
                                action: BlogAdminRoutes.postRemove()
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
                                        name: "blog-posts",
                                        columns: [
                                            .fraction(2), .fraction(1),
                                            .fraction(1), .fraction(1),
                                            .fixed(220),
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
                                                Th("Expiration")
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
                                                    Td {
                                                        A(item.title)
                                                            .href(
                                                                BlogAdminRoutes
                                                                    .post(
                                                                        RouterPath(
                                                                            item
                                                                                .id
                                                                        )
                                                                    )
                                                                    .description
                                                            )
                                                    }
                                                    .data("label", "Title")
                                                    Td {
                                                        if state.canEdit {
                                                            context.render(
                                                                NewAdminStatusSelectField(
                                                                    formID:
                                                                        statusFormID(
                                                                            item
                                                                                .id
                                                                        ),
                                                                    selectedStatus:
                                                                        item
                                                                        .metadata
                                                                        .normalizedStatus
                                                                )
                                                            )
                                                        }
                                                        else {
                                                            context.render(
                                                                statusChip(
                                                                    item
                                                                        .metadata
                                                                        .normalizedStatus
                                                                )
                                                            )
                                                        }
                                                    }
                                                    .data("label", "Status")
                                                    Td(
                                                        format(
                                                            item.metadata
                                                                .publicationDate
                                                        )
                                                    )
                                                    .data(
                                                        "label",
                                                        "Publication"
                                                    )
                                                    Td(
                                                        format(
                                                            item.metadata
                                                                .expirationDate
                                                        )
                                                    )
                                                    .data("label", "Expiration")
                                                    context.render(
                                                        NewAdminListRowActions(
                                                            label: "Actions",
                                                            actions: [
                                                                .init(
                                                                    "Details",
                                                                    href:
                                                                        BlogAdminRoutes
                                                                        .post(
                                                                            RouterPath(
                                                                                item
                                                                                    .id
                                                                            )
                                                                        )
                                                                        .description,
                                                                    permission:
                                                                        BlogPermissions
                                                                        .Posts
                                                                        .read
                                                                ),
                                                                .init(
                                                                    "Edit",
                                                                    href:
                                                                        BlogAdminRoutes
                                                                        .postEdit(
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
                                                                        .Posts
                                                                        .update
                                                                ),
                                                                .init(
                                                                    "Remove",
                                                                    href:
                                                                        NewAdminLocation
                                                                        .remove(
                                                                            path:
                                                                                BlogAdminRoutes
                                                                                .postRemove()
                                                                                .description,
                                                                            ids: [
                                                                                item
                                                                                    .id
                                                                            ],
                                                                            returnTo:
                                                                                BlogAdminRoutes
                                                                                .posts
                                                                                .description
                                                                        ),
                                                                    style:
                                                                        .destructive,
                                                                    permission:
                                                                        BlogPermissions
                                                                        .Posts
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
                            action: BlogAdminRoutes.posts.description,
                            placeholder: "Search blog posts",
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
                                    "Add post",
                                    href: BlogAdminRoutes.postAdd().description
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
                            path: BlogAdminRoutes.posts.description,
                            pageState: state.pageState,
                            search: state.search
                        )
                    )
                )
            }
        )
        .html(context: &context)
    }

    private func statusFormID(_ id: String) -> String {
        "blog-post-status-\(id)"
    }

    private func statusChip(_ status: String) -> NewAdminChip {
        .init(
            label: status.capitalized,
            color: status == "published"
                ? .green : (status == "archived" ? .red : .yellow)
        )
    }

    private func format(_ value: String) -> String {
        guard let timestamp = AdminMetadataSchemaBuilder.parseTimestamp(value)
        else { return "-" }
        return DateFormatting.formatUnixTimestamp(timestamp)
    }
}
