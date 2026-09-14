import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct WebPageTable: Component {
    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let isPublished: Bool
        let isUnpublished: Bool
        let canAccess: Bool
        let canEdit: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let rules: [AdminListWebPageItemModel]
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
                WebPermissions.Pages.allPermissions().filter {
                    state.permissions.contains($0.rawValue)
                }
            )
        )
    }

    private var returnTo: String {
        NewAdminLocation.url(
            path: WebPageRoutes.list.description,
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
                        title: "Web pages",
                        description: "Manage the pages published on the website."
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
                statusFormDefinitions(context: &context)
                if state.isAdded { P("Web page added successfully.") }
                if state.isEdited { P("Web page edited successfully.") }
                if state.isRemoved { P("Web page removed successfully.") }
                if state.isPublished { P("Web page published successfully.") }
                if state.isUnpublished { P("Web page unpublished successfully.") }

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
                            else if state.rules.isEmpty {
                                if state.search.isEmpty {
                                    context.render(
                                        NewAdminListEmptyState(
                                            message: "No web pages yet.",
                                            icon: FeatherIcons.inbox(),
                                            action: {
                                                if state.canAdd {
                                                    context.render(
                                                        NewAdminButton(
                                                            "Add new",
                                                            href: WebPageRoutes.add.description
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
                                            message: "No web pages match your search.",
                                            icon: FeatherIcons.inbox(),
                                            action: {
                                                context.render(
                                                    NewAdminButton(
                                                        "Reset search",
                                                        href: WebPageRoutes.list.description,
                                                        style: .secondary
                                                    )
                                                )
                                            }
                                        )
                                    )
                                }
                            }
                            else {
                                let canDelete = actions.allows(WebPermissions.Pages.delete)
                                context.render(
                                    NewAdminListSelectionForm(
                                        state: .init(
                                            action: WebPageRoutes.remove.description,
                                            pageState: pageState,
                                            search: state.search,
                                            button: .init("Remove selected", style: .destructive),
                                            isEnabled: canDelete
                                        ),
                                        table: context.render(
                                            NewAdminListShell(
                                                layout: .init(
                                                    name: "web-pages",
                                                    columns: [
                                                        .fraction(2),
                                                        .fixed(140),
                                                        .fixed(140),
                                                        .fixed(140),
                                                        .fixed(250),
                                                    ]
                                                ),
                                                hasSelection: canDelete,
                                                table: Table {
                                                    Thead {
                                                        Tr {
                                                            if canDelete {
                                                                context.render(NewAdminListSelectAllCheckbox())
                                                            }
                                                            Th("Title")
                                                            Th("Status")
                                                            Th("Publication")
                                                            Th("Expiration")
                                                            Th("Actions")
                                                        }
                                                    }
                                                    Tbody {
                                                        for item in state.rules {
                                                            Tr {
                                                                if canDelete {
                                                                    context.render(NewAdminListRowCheckbox(id: item.id))
                                                                }
                                                                titleCell(for: item)
                                                                statusCell(for: item, context: &context)
                                                                Td(format(item.metadata.publicationDate)).data("label", "Publication")
                                                                Td(format(item.metadata.expirationDate)).data("label", "Expiration")
                                                                context.render(
                                                                    NewAdminListRowActions(
                                                                        label: "Actions",
                                                                        actions: [
                                                                            .init("View", href: WebPageRoutes.details(RouterPath(item.id)).description, style: .ghost(.primary), permission: WebPermissions.Pages.read),
                                                                            .init("Edit", href: WebPageRoutes.edit(RouterPath(item.id)).description, style: .ghost(.secondary), permission: WebPermissions.Pages.update),
                                                                            .init("Remove", href: WebPageRoutes.details(RouterPath(item.id)).appendingPath(RouterPath("remove")).description, style: .destructive, permission: WebPermissions.Pages.delete),
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
                                        action: WebPageRoutes.list.description,
                                        placeholder: "Quick search web pages",
                                        search: state.search
                                    )
                                )
                            )
                        },
                        toolbar: {
                            if state.canAdd {
                                context.render(
                                    NewAdminListToolbar {
                                        context.render(NewAdminButton("Add new", href: WebPageRoutes.add.description))
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

    private func titleCell(for item: AdminListWebPageItemModel) -> Td {
        Td {
            Span {
                Span(item.title)
                if let previewPath = previewPath(for: item.metadata) {
                    A { FeatherIcons.externalLink() }
                        .href(previewPath)
                        .target(.blank)
                        .ariaLabel("Preview \(item.title)")
                }
            }
        }
        .data("label", "Title")
    }

    private func statusCell(
        for item: AdminListWebPageItemModel,
        context: inout RenderContext
    ) -> Td {
        Td {
            if state.canEdit {
                context.render(
                    AdminStatusSelectField(
                        formID: statusFormID(for: item.id),
                        selectedStatus: item.metadata.normalizedStatus
                    )
                )
            }
            else {
                Span(item.metadata.status.capitalized)
            }
        }
        .data("label", "Status")
    }

    private func statusFormDefinitions(context: inout RenderContext) -> some FlowContent {
        Div {
            if state.canEdit {
                for item in state.rules {
                    context.render(
                        AdminStatusSelectFormDefinition(
                            id: statusFormID(for: item.id),
                            action: WebPageRoutes.status(RouterPath(item.id)).description,
                            returnTo: WebPageRoutes.list.description
                        )
                    )
                }
            }
        }
        .style("display:none;")
    }

    private func statusFormID(for id: String) -> String { "web-page-status-\(id)" }

    private func format(_ value: String) -> String {
        guard let timestamp = AdminMetadataSchemaBuilder.parseTimestamp(value) else { return "-" }
        return DateFormatting.formatUnixTimestamp(timestamp)
    }

    private func previewPath(for metadata: AdminMetadataFormValue) -> String? {
        let slug = metadata.normalizedSlug
        return slug.isEmpty ? nil : "/\(slug)/"
    }
}
