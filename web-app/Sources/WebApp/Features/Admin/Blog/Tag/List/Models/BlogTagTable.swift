import FeatherValidation
import Foundation
import HTML
import Hummingbird
import SGML
import WebStandards

struct BlogTagTable: Component {

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
        let rules: [AdminListBlogTagItemModel]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let deniedInfo: String
        let deniedMessage: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb)
                H1("Blog tags")
                statusFormDefinitions()

                if state.isAdded {
                    P("Blog tag added successfully.")
                }
                if state.isEdited {
                    P("Blog tag edited successfully.")
                }
                if state.isRemoved {
                    P("Blog tag removed successfully.")
                }
                if state.isPublished {
                    P("Blog tag published successfully.")
                }
                if state.isUnpublished {
                    P("Blog tag unpublished successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add tag",
                            href: "/admin/blog/tags/add/"
                        )
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/blog/tags/",
                        placeholder: "Quick search blog tags",
                        search: state.search
                    )
                )

                if state.rules.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1").href("/admin/blog/tags/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/blog/tags/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No blog tags yet."
                                : "No blog tags match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "blog:tags:delete"
                    )
                    ListTableBulkRemoveForm(
                        state: .init(
                            action: "/admin/blog/tags/bulk-remove/",
                            page: state.page,
                            search: state.search,
                            canRemove: canRemove,
                            buttonTitle: "Remove selected"
                        ),
                        table: ListTableShell(
                            table: Table {
                                Thead {
                                    Tr {
                                        if canRemove {
                                            ListTableSelectAllCheckbox()
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
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(
                                                        id: item.id
                                                    )
                                                )
                                            }
                                            titleCell(for: item)
                                            statusCell(for: item)
                                            Td(
                                                format(
                                                    item.metadata
                                                        .publicationDate
                                                )
                                            )
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Publication"
                                            )
                                            Td(
                                                format(
                                                    item.metadata.expirationDate
                                                )
                                            )
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Expiration"
                                            )
                                            actionsCell(for: item)
                                        }
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canRemove) { $0.class("bulk-select-table") }
                        )
                    )
                    ListTablePagination(
                        state: .init(
                            path: "/admin/blog/tags/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search
                        )
                    )
                }
            }
        }
        .class("cms-section")
    }

    private func actionsCell(
        for item: AdminListBlogTagItemModel
    ) -> some BasicTag {
        Td {
            if state.permissions.contains(
                AdminBlog.Scope.tags.permission(for: .read)
            ) {
                A("Details")
                    .href("/admin/blog/tags/\(item.id)/")
                    .class("row-btn")
                Span(" ")
            }
            if state.permissions.contains(
                AdminBlog.Scope.tags.permission(for: .update)
            ) {
                A("Edit")
                    .href("/admin/blog/tags/\(item.id)/edit/")
                    .class("row-btn", "edit")
                Span(" ")
            }
            if state.permissions.contains(
                AdminBlog.Scope.tags.permission(for: .delete)
            ) {
                A("Remove")
                    .href("/admin/blog/tags/\(item.id)/remove/")
                    .class("row-btn", "delete")
            }
        }
        .setAttribute(name: "data-label", value: "Actions")
        .class("action-cell")
    }

    private func titleCell(
        for item: AdminListBlogTagItemModel
    ) -> some BasicTag {
        Td {
            Span {
                Span(item.title)
                if let previewPath = previewPath(for: item.metadata) {
                    A {
                        Icon(svg: FeatherIcons.externalLink())
                    }
                    .href(previewPath)
                    .setAttribute(name: "target", value: "_blank")
                    .setAttribute(
                        name: "aria-label",
                        value: "Preview \(item.title)"
                    )
                    .style(
                        "display:inline-flex;align-items:center;justify-content:center;width:0.95rem;height:0.95rem;flex:0 0 auto;"
                    )
                }
            }
            .style(
                "display:inline-flex;align-items:center;gap:0.35rem;vertical-align:middle;line-height:1.25;position:relative;top:1px;"
            )
        }
        .setAttribute(name: "data-label", value: "Title")
    }

    private func statusCell(
        for item: AdminListBlogTagItemModel
    ) -> some BasicTag {
        Td {
            if state.canEdit {
                AdminStatusSelectField(
                    formID: statusFormID(for: item.id),
                    selectedStatus: item.metadata.normalizedStatus
                )
            }
            else {
                Span(item.metadata.status.capitalized)
            }
        }
        .setAttribute(name: "data-label", value: "Status")
    }

    private func statusFormDefinitions() -> some FlowContent {
        Div {
            if state.canEdit {
                for item in state.rules {
                    AdminStatusSelectFormDefinition(
                        id: statusFormID(for: item.id),
                        action: "/admin/blog/tags/\(item.id)/status/",
                        returnTo: "/admin/blog/tags/"
                    )
                }
            }
        }
        .style("display:none;")
    }

    private func statusFormID(
        for id: String
    ) -> String {
        "blog-tag-status-\(id)"
    }

    private func format(
        _ value: String
    ) -> String {
        guard let timestamp = AdminMetadataSchemaBuilder.parseTimestamp(value)
        else {
            return "-"
        }
        return DateFormatting.formatUnixTimestamp(timestamp)
    }

    private func previewPath(
        for metadata: AdminMetadataFormValue
    ) -> String? {
        let slug = metadata.normalizedSlug
        return slug.isEmpty ? nil : "/\(slug)/"
    }
}
