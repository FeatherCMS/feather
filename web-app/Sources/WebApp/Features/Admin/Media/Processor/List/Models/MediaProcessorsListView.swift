import AdminOpenAPI
import HTML
import SGML
import WebStandards

struct MediaProcessorsListView: Component {
    let items: [Components.Schemas.MediaProcessorListItemSchema]
    let page: Int
    let pageSize: Int
    let total: Int
    let isAdded: Bool
    let isEdited: Bool
    let isRemoved: Bool
    let canAccess: Bool
    let permissions: Set<String>
    let canAdd: Bool
    let deniedInfo: String
    let deniedMessage: String
    let breadcrumb: AdminBreadcrumb.State

    func content() -> some BasicTag {
        Section {
            if !canAccess {
                H1(deniedInfo)
                P(deniedMessage)
            }
            else {
                AdminBreadcrumb(state: breadcrumb)
                H1("Processors")

                if isAdded { P("Processor added successfully.") }
                if isEdited { P("Processor edited successfully.") }
                if isRemoved { P("Processor removed successfully.") }
                if canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add processor",
                            href: "/admin/media/processors/add/"
                        )
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                if items.isEmpty {
                    let totalPages = max(1, (total + pageSize - 1) / pageSize)
                    if total > 0 && page > totalPages {
                        P("Page \(page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1").href("/admin/media/processors/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/media/processors/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P("No processors yet.")
                    }
                }
                else {
                    let canRemove = permissions.contains(
                        "media:processors:delete"
                    )
                    ListTableBulkRemoveForm(
                        state: .init(
                            action: "/admin/media/processors/bulk-remove/",
                            page: page,
                            search: "",
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
                                        Th("File suffix")
                                            .columnWidth(percent: 50)
                                        Th("Match extensions")
                                            .columnWidth(percent: 50)
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for item in items {
                                        Tr {
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(id: item.id)
                                                )
                                            }
                                            Td(item.name)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "File suffix"
                                                )
                                                .columnWidth(percent: 50)
                                            Td(item.matchExtensions)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Match extensions"
                                                )
                                                .columnWidth(percent: 50)
                                            ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/media/processors/\(item.id)/",
                                                            className: nil,
                                                            permission:
                                                                "media:processors:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/media/processors/\(item.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "media:processors:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/media/processors/\(item.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "media:processors:delete"
                                                        ),
                                                    ],
                                                    permissions: permissions
                                                )
                                            )
                                        }
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canRemove) { $0.class("bulk-select-table") }
                        )
                    )
                }
                ListTablePagination(
                    state: .init(
                        path: "/admin/media/processors/",
                        page: page,
                        pageSize: pageSize,
                        total: total,
                        search: ""
                    )
                )
            }
        }
        .class("cms-section")
    }
}
