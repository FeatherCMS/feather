import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import MediaWebAdmin
import SGML
import WebBuilders
import WebComponents
import WebModule
import WebModuleWebAdmin

extension Author.List {
    struct Component: WebComponents.Component {
        struct State {
            let canAccess: Bool
            let canEdit: Bool
            let canAdd: Bool
            let items: [Author.List.Item]
            let pageState: AdminListPageState
            let search: String
            let permissions: AdminListActions
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Author.Router.Routes
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
                                    "Your account cannot access blog authors."
                            ),
                            icon: FeatherIcons.alertCircle()
                        )
                    )
                }
                else {
                    context.build(
                        AdminPageHeader(
                            state: .primary(
                                title: "Blog authors",
                                description:
                                    "Manage authors and their publication status."
                            )
                        )
                    )
                    if let error = state.error {
                        P(error).class("admin-form__error")
                    }
                    context.build(TableContent(state: state))
                }
            }
            .class("cms-section")
        }
    }

    private struct TableContent: WebComponents.Component {
        let state: Component.State

        func html(context: inout BuilderContext) -> Div {
            let canDelete = state.permissions.allows(
                Author.Permissions.delete
            )
            return context.build(
                AdminList(
                    table: {
                        if state.items.isEmpty {
                            context.build(
                                AdminListNoResultsState(
                                    message: state.search.isEmpty
                                        ? "No blog authors yet."
                                        : "No blog authors match your search."
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
                                                .authorStatus(item.id),
                                            returnTo: state.routes.authors.path
                                        )
                                    )
                                }
                            }
                            context.build(
                                AdminListSelectionForm(
                                    state: .init(
                                        action: state.routes
                                            .authorRemove(),
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
                                                name: "blog-authors",
                                                columns: [
                                                    .fixed(84), .fraction(2),
                                                    .fraction(1), .fraction(1),
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
                                                                context.build(
                                                                    AdminListRowCheckbox(
                                                                        id: item
                                                                            .id
                                                                    )
                                                                )
                                                            }
                                                            Td {
                                                                context.build(
                                                                    AdminImageCell(
                                                                        imageURL:
                                                                            item
                                                                            .profileImage?
                                                                            .originalURL,
                                                                        alt:
                                                                            item
                                                                            .profileImage?
                                                                            .altText
                                                                            ?? item
                                                                            .profileImage?
                                                                            .title
                                                                            ?? item
                                                                            .name,
                                                                        size:
                                                                            .square
                                                                    )
                                                                )
                                                            }
                                                            .data(
                                                                "label",
                                                                "Profile"
                                                            )
                                                            Td {
                                                                A(item.name)
                                                                    .href(
                                                                        state
                                                                            .routes
                                                                            .author(
                                                                                item
                                                                                    .id
                                                                            )
                                                                    )
                                                            }
                                                            .data(
                                                                "label",
                                                                "Name"
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
                                                                                .author(
                                                                                    item
                                                                                        .id
                                                                                ),
                                                                            style:
                                                                                .ghost(
                                                                                    .primary
                                                                                ),
                                                                            permission:
                                                                                Author
                                                                                .Permissions
                                                                                .read
                                                                        ),
                                                                        .init(
                                                                            "Edit",
                                                                            href:
                                                                                state
                                                                                .routes
                                                                                .authorEdit(
                                                                                    item
                                                                                        .id
                                                                                ),
                                                                            style:
                                                                                .ghost(
                                                                                    .secondary
                                                                                ),
                                                                            permission:
                                                                                Author
                                                                                .Permissions
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
                                                                                        .authorRemove(),
                                                                                    ids: [
                                                                                        item
                                                                                            .id
                                                                                    ],
                                                                                    returnTo:
                                                                                        state
                                                                                        .routes
                                                                                        .authors
                                                                                        .path
                                                                                ),
                                                                            style:
                                                                                .destructive,
                                                                            permission:
                                                                                Author
                                                                                .Permissions
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
                                    action: state.routes.authors.path,
                                    placeholder: "Search blog authors",
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
                                            "Add author",
                                            href: state.routes.authorAdd()
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
                                    path: state.routes.authors.path,
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
        private func statusChip(_ status: String) -> AdminChip {
            .init(
                label: status.capitalized,
                color: status == "published"
                    ? .green : (status == "archived" ? .red : .yellow)
            )
        }
        private func format(_ value: String) -> String {
            guard
                let timestamp = WebModule.Metadata.SchemaBuilder.parseTimestamp(
                    value
                )
            else { return "-" }
            return DateFormatting.formatUnixTimestamp(timestamp)
        }
    }
}
