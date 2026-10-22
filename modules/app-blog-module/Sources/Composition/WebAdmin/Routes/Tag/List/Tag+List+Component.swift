import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherModuleKit
import FeatherWebAdmin
import Foundation
import HTML
import Hummingbird
import WebBuilders
import WebComponents
import WebModuleWebAdmin

import protocol SGML.BasicTag

extension Tag.List {
    struct Component: WebComponents.Component {
        struct State {
            let canAccess: Bool
            let canEdit: Bool
            let canAdd: Bool
            let items: [Tag.List.Item]
            let pageState: AdminListPageState
            let search: String
            let permissions: AdminListActions
            let breadcrumb: [AdminBreadcrumb.Link]
            let error: String?
            let routes: Tag.Router.Routes
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
                                message: "Your account cannot access blog tags."
                            ),
                            icon: FeatherIcons.alertCircle()
                        )
                    )
                }
                else {
                    context.build(
                        AdminPageHeader(
                            state: .primary(
                                title: "Blog tags",
                                description:
                                    "Manage tags and their publication status."
                            )
                        )
                    )
                    if let error = state.error {
                        P(error).class("admin-form__error")
                    }
                    context.build(Tag.List.TableContent(state: state))
                }
            }
            .class("cms-section")
        }
    }
}

extension Tag.List {
    fileprivate struct TableContent: WebComponents.Component {
        let state: Component.State
        func html(context: inout BuilderContext) -> Div {
            let canDelete = state.permissions.allows(
                Tag.Permissions.delete
            )
            return context.build(
                AdminList(
                    table: {
                        if state.items.isEmpty {
                            context.build(
                                AdminListNoResultsState(
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
                                        AdminStatusSelectFormDefinition(
                                            id: statusFormID(item.id),
                                            action:
                                                state.routes
                                                .tagStatus(
                                                    RouterPath(item.id)
                                                )
                                                .description,
                                            returnTo: state.routes.tags
                                                .description
                                        )
                                    )
                                }
                            }
                            context.build(
                                AdminListSelectionForm(
                                    state: .init(
                                        action: state.routes.tagRemove()
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
                                                                AdminListSelectAllCheckbox()
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
                                                                    AdminListRowCheckbox(
                                                                        id: item
                                                                            .id
                                                                    )
                                                                )
                                                            }
                                                            Td {
                                                                A(item.title)
                                                                    .href(
                                                                        state
                                                                            .routes
                                                                            .tag(
                                                                                RouterPath(
                                                                                    item
                                                                                        .id
                                                                                )
                                                                            )
                                                                            .description
                                                                    )
                                                            }
                                                            .data(
                                                                "label",
                                                                "Title"
                                                            )
                                                            .data(
                                                                "remove-label",
                                                                "true"
                                                            )
                                                            Td {
                                                                if state.canEdit
                                                                {
                                                                    context
                                                                        .build(
                                                                            AdminStatusSelectField(
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
                                                                    context
                                                                        .build(
                                                                            statusChip(
                                                                                item
                                                                                    .metadata
                                                                                    .normalizedStatus
                                                                            )
                                                                        )
                                                                }
                                                            }
                                                            .data(
                                                                "label",
                                                                "Status"
                                                            )
                                                            Td(
                                                                format(
                                                                    item
                                                                        .metadata
                                                                        .publicationDate
                                                                )
                                                            )
                                                            .data(
                                                                "label",
                                                                "Publication"
                                                            )
                                                            Td(
                                                                format(
                                                                    item
                                                                        .metadata
                                                                        .expirationDate
                                                                )
                                                            )
                                                            .data(
                                                                "label",
                                                                "Expiration"
                                                            )
                                                            context.build(
                                                                AdminListRowActions(
                                                                    label:
                                                                        "Actions",
                                                                    actions: [
                                                                        .init(
                                                                            "View",
                                                                            href:
                                                                                state
                                                                                .routes
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
                                                                                Tag.Permissions
                                                                                .read
                                                                        ),
                                                                        .init(
                                                                            "Edit",
                                                                            href:
                                                                                state
                                                                                .routes
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
                                                                                Tag.Permissions
                                                                                .update
                                                                        ),
                                                                        .init(
                                                                            "Delete",
                                                                            href:
                                                                                AdminLocation
                                                                                .remove(
                                                                                    path:
                                                                                        state
                                                                                        .routes
                                                                                        .tagRemove()
                                                                                        .description,
                                                                                    ids: [
                                                                                        item
                                                                                            .id
                                                                                    ],
                                                                                    returnTo:
                                                                                        state
                                                                                        .routes
                                                                                        .tags
                                                                                        .description
                                                                                ),
                                                                            style:
                                                                                .destructive,
                                                                            permission:
                                                                                Tag.Permissions
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
                            AdminListSearch(
                                state: .init(
                                    action: state.routes.tags.description,
                                    placeholder: "Search blog tags",
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
                                            "Add tag",
                                            href: state.routes.tagAdd()
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
                                    path: state.routes.tags.description,
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
        private func statusChip(_ status: String) -> AdminChip {
            .init(
                label: status.capitalized,
                color: status == "published"
                    ? .green : (status == "archived" ? .red : .yellow)
            )
        }
        private func format(_ value: String) -> String {
            guard
                let timestamp = AdminMetadataSchemaBuilder.parseTimestamp(value)
            else { return "-" }
            return DateFormatting.formatUnixTimestamp(timestamp)
        }
    }
}
