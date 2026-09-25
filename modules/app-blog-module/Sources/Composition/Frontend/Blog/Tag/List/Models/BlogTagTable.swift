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

struct BlogTagTable: Component {
    struct State {
        let canAccess: Bool
        let canEdit: Bool
        let canAdd: Bool
        let items: [AdminListBlogTagItemModel]
        let pageState: NewAdminListPageState
        let search: String
        let permissions: NewAdminListActions
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let error: String?
    }
    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            if !state.canAccess {
                context.build(
                    NewAdminStatusView(
                        state: .init(
                            title: "Forbidden",
                            message: "Your account cannot access blog tags."
                        ),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
            else {
                context.build(
                    NewAdminPageHeader(
                        state: .init(
                            title: "Blog tags",
                            description:
                                "Manage tags and their publication status."
                        )
                    )
                )
                if let error = state.error {
                    P(error).class("new-admin-form__error")
                }
                context.build(BlogTagTableContent(state: state))
            }
        }
        .class("cms-section")
    }
}

private struct BlogTagTableContent: Component {
    let state: BlogTagTable.State
    func html(context: inout BuilderContext) -> Div {
        let canDelete = state.permissions.allows(BlogPermissions.Tags.delete)
        return context.build(
            NewAdminList(
                table: {
                    if state.items.isEmpty {
                        context.build(
                            NewAdminListNoResultsState(
                                message: state.search.isEmpty
                                    ? "No blog tags yet."
                                    : "No blog tags match your search."
                            )
                        )
                    }
                    else {
                        if state.canEdit {
                            for item in state.items {
                                context.build(
                                    NewAdminStatusSelectFormDefinition(
                                        id: statusFormID(item.id),
                                        action:
                                            BlogAdminRoutes.tagStatus(
                                                RouterPath(item.id)
                                            )
                                            .description,
                                        returnTo: BlogAdminRoutes.tags
                                            .description
                                    )
                                )
                            }
                        }
                        context.build(
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: BlogAdminRoutes.tagRemove()
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
                                    NewAdminListShell(
                                        layout: .init(
                                            name: "blog-tags",
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
                                                        context.build(
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
                                                            context.build(
                                                                NewAdminListRowCheckbox(
                                                                    id: item.id
                                                                )
                                                            )
                                                        }
                                                        Td {
                                                            A(item.title)
                                                                .href(
                                                                    BlogAdminRoutes
                                                                        .tag(
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
                                                                context.build(
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
                                                                context.build(
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
                                                        .data(
                                                            "label",
                                                            "Expiration"
                                                        )
                                                        context.build(
                                                            NewAdminListRowActions(
                                                                label:
                                                                    "Actions",
                                                                actions: [
                                                                    .init(
                                                                        "View",
                                                                        href:
                                                                            BlogAdminRoutes
                                                                            .tag(
                                                                                RouterPath(
                                                                                    item
                                                                                        .id
                                                                                )
                                                                            )
                                                                            .description,
                                                                        style:
                                                                            .ghost(
                                                                                .primary
                                                                            ),
                                                                        permission:
                                                                            BlogPermissions
                                                                            .Tags
                                                                            .read
                                                                    ),
                                                                    .init(
                                                                        "Edit",
                                                                        href:
                                                                            BlogAdminRoutes
                                                                            .tagEdit(
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
                                                                            .Tags
                                                                            .update
                                                                    ),
                                                                    .init(
                                                                        "Delete",
                                                                        href:
                                                                            NewAdminLocation
                                                                            .remove(
                                                                                path:
                                                                                    BlogAdminRoutes
                                                                                    .tagRemove()
                                                                                    .description,
                                                                                ids: [
                                                                                    item
                                                                                        .id
                                                                                ],
                                                                                returnTo:
                                                                                    BlogAdminRoutes
                                                                                    .tags
                                                                                    .description
                                                                            ),
                                                                        style:
                                                                            .destructive,
                                                                        permission:
                                                                            BlogPermissions
                                                                            .Tags
                                                                            .delete
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
                        NewAdminListSearch(
                            state: .init(
                                action: BlogAdminRoutes.tags.description,
                                placeholder: "Search blog tags",
                                search: state.search
                            )
                        )
                    )
                },
                toolbar: {
                    if state.canAdd {
                        context.build(
                            NewAdminListToolbar {
                                context.build(
                                    NewAdminButton(
                                        "Add tag",
                                        href: BlogAdminRoutes.tagAdd()
                                            .description
                                    )
                                )
                            }
                        )
                    }
                },
                pagination: {
                    context.build(
                        NewAdminListPagination(
                            state: .init(
                                path: BlogAdminRoutes.tags.description,
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
        "blog-tag-status-\(id)"
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
