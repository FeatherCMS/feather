import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebContracts
import WebComponents
import WebBuilders

struct WebPageTable: Leaf {

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
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb).html()
                H1("Web pages")
                statusFormDefinitions()

                if state.isAdded {
                    P("Web page added successfully.")
                }
                if state.isEdited {
                    P("Web page edited successfully.")
                }
                if state.isRemoved {
                    P("Web page removed successfully.")
                }
                if state.isPublished {
                    P("Web page published successfully.")
                }
                if state.isUnpublished {
                    P("Web page unpublished successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add page",
                            href: "/admin/web/pages/add/"
                        ).html()
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/web/pages/",
                        placeholder: "Quick search web pages",
                        search: state.search
                    )
                ).html()

                if state.rules.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1").href("/admin/web/pages/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/web/pages/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No web pages yet."
                                : "No web pages match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "web:pages:delete"
                    )
                    ListTableRemoveForm(
                        state: .init(
                            action: "/admin/web/pages/remove/",
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
                                            ListTableSelectAllCheckbox().html()
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
                                                ).html()
                                            }
                                            titleCell(for: item)
                                            statusCell(for: item)
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
                                                    item.metadata.expirationDate
                                                )
                                            )
                                            .data(
                                                "label",
                                                "Expiration"
                                            )
                                            actionsCell(for: item)
                                        }
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canRemove) { $0.class("select-table") }
                        ).html()
                    ).html()
                    ListTablePagination(
                        state: .init(
                            path: "/admin/web/pages/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search
                        )
                    ).html()
                }
            }
        }
        .class("cms-section")
    }

    private func actionsCell(
        for item: AdminListWebPageItemModel
    ) -> some BasicTag {
        Td {
            if state.permissions.contains(
                WebPermissions.Pages.read.rawValue
            ) {
                A("Details")
                    .href("/admin/web/pages/\(item.id)/")
                    .class("row-btn")
                Span(" ")
            }
            if state.permissions.contains(
                WebPermissions.Pages.update.rawValue
            ) {
                A("Edit")
                    .href("/admin/web/pages/\(item.id)/edit/")
                    .class("row-btn", "edit")
                Span(" ")
            }
            if state.permissions.contains(
                WebPermissions.Pages.delete.rawValue
            ) {
                A("Remove")
                    .href("/admin/web/pages/\(item.id)/remove/")
                    .class("row-btn", "delete")
            }
        }
        .data("label", "Actions")
        .class("action-cell")
    }

    private func titleCell(
        for item: AdminListWebPageItemModel
    ) -> some BasicTag {
        Td {
            Span {
                Span(item.title)
                if let previewPath = previewPath(for: item.metadata) {
                    A {
                        Icon(svg: FeatherIcons.externalLink()).html()
                    }
                    .href(previewPath)
                    .target(.blank)
                    .ariaLabel("Preview \(item.title)")
                    .style(
                        "display:inline-flex;align-items:center;justify-content:center;width:0.95rem;height:0.95rem;flex:0 0 auto;"
                    )
                }
            }
            .style(
                "display:inline-flex;align-items:center;gap:0.35rem;vertical-align:middle;line-height:1.25;position:relative;top:1px;"
            )
        }
        .data("label", "Title")
    }

    private func statusCell(
        for item: AdminListWebPageItemModel
    ) -> some BasicTag {
        Td {
            if state.canEdit {
                AdminStatusSelectField(
                    formID: statusFormID(for: item.id),
                    selectedStatus: item.metadata.normalizedStatus
                ).html()
            }
            else {
                Span(item.metadata.status.capitalized)
            }
        }
        .data("label", "Status")
    }

    private func statusFormDefinitions() -> some FlowContent {
        Div {
            if state.canEdit {
                for item in state.rules {
                    AdminStatusSelectFormDefinition(
                        id: statusFormID(for: item.id),
                        action: "/admin/web/pages/\(item.id)/status/",
                        returnTo: "/admin/web/pages/"
                    ).html()
                }
            }
        }
        .style("display:none;")
    }

    private func statusFormID(
        for id: String
    ) -> String {
        "web-page-status-\(id)"
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
