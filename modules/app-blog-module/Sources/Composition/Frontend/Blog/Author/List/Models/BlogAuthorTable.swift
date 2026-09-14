import BlogAdminAPI
import BlogAppAPI
import BlogContracts
import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct BlogAuthorTable: Component {
    struct State {
        let canAccess: Bool
        let canEdit: Bool
        let canAdd: Bool
        let items: [AdminListBlogAuthorItemModel]
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
                            message: "Your account cannot access blog authors."
                        ),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
            else {
                context.render(
                    NewAdminPageHeader(
                        state: .init(
                            title: "Blog authors",
                            description:
                                "Manage authors and their publication status."
                        )
                    )
                )
                if let error = state.error {
                    P(error).class("new-admin-form__error")
                }
                context.render(BlogAuthorTableContent(state: state))
            }
        }
        .class("cms-section")
    }
}

private struct BlogAuthorTableContent: Component {
    let state: BlogAuthorTable.State

    func html(context: inout RenderContext) -> Div {
        let canDelete = state.permissions.allows(BlogPermissions.Authors.delete)
        return context.render(
            NewAdminList(
            table: {
                if state.items.isEmpty {
                    context.render(
                        NewAdminListNoResultsState(
                            message: state.search.isEmpty
                                ? "No blog authors yet."
                                : "No blog authors match your search."
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
                                        BlogAdminRoutes.authorStatus(
                                            RouterPath(item.id)
                                        )
                                        .description,
                                    returnTo: BlogAdminRoutes.authors
                                        .description
                                )
                            )
                        }
                    }
                    context.render(
                        NewAdminListSelectionForm(
                            state: .init(
                                action: BlogAdminRoutes.authorRemove()
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
                                        name: "blog-authors",
                                        columns: [
                                            .fixed(64), .fraction(2),
                                            .fraction(1), .fraction(1),
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
                                                Th("Profile")
                                                Th("Name")
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
                                                        if let image = item
                                                            .profileImage
                                                        {
                                                            Img(
                                                                src:
                                                                    "/media/\(image.storageKey)",
                                                                alt: image
                                                                    .altText
                                                                    ?? image
                                                                    .title
                                                                    ?? item.name
                                                            )
                                                            .class(
                                                                "blog-author-list-profile-image"
                                                            )
                                                        }
                                                        else {
                                                            Span("—")
                                                        }
                                                    }
                                                    .data("label", "Profile")
                                                    .class(
                                                        "blog-author-list-profile-cell"
                                                    )
                                                    Td {
                                                        A(item.name)
                                                            .href(
                                                                BlogAdminRoutes
                                                                    .author(
                                                                        RouterPath(
                                                                            item
                                                                                .id
                                                                        )
                                                                    )
                                                                    .description
                                                            )
                                                    }
                                                    .data("label", "Name")
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
                                                                        .author(
                                                                            RouterPath(
                                                                                item
                                                                                    .id
                                                                            )
                                                                        )
                                                                        .description,
                                                                    permission:
                                                                        BlogPermissions
                                                                        .Authors
                                                                        .read
                                                                ),
                                                                .init(
                                                                    "Edit",
                                                                    href:
                                                                        BlogAdminRoutes
                                                                        .authorEdit(
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
                                                                        .Authors
                                                                        .update
                                                                ),
                                                                .init(
                                                                    "Remove",
                                                                    href:
                                                                        NewAdminLocation
                                                                        .remove(
                                                                            path:
                                                                                BlogAdminRoutes
                                                                                .authorRemove()
                                                                                .description,
                                                                            ids: [
                                                                                item
                                                                                    .id
                                                                            ],
                                                                            returnTo:
                                                                                BlogAdminRoutes
                                                                                .authors
                                                                                .description
                                                                        ),
                                                                    style:
                                                                        .destructive,
                                                                    permission:
                                                                        BlogPermissions
                                                                        .Authors
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
                            action: BlogAdminRoutes.authors.description,
                            placeholder: "Search blog authors",
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
                                    "Add author",
                                    href: BlogAdminRoutes.authorAdd()
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
                            path: BlogAdminRoutes.authors.description,
                            pageState: state.pageState,
                            search: state.search
                        )
                    )
                )
            }
            )
        )
    }

    private func statusFormID(_ id: String) -> String {
        "blog-author-status-\(id)"
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
