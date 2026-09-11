import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

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

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            if !canAccess {
                H1(deniedInfo)
                P(deniedMessage)
            }
            else {
                context.render(AdminBreadcrumb(state: breadcrumb))
                H1("Processors")

                if isAdded { P("Processor added successfully.") }
                if isEdited { P("Processor edited successfully.") }
                if isRemoved { P("Processor removed successfully.") }
                if canAdd {
                    Div {
                        context.render(
                            AdminNavigationButton(
                                "Add processor",
                                href: "/admin/media/processors/add/"
                            )
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
                    context.render(
                        ListTableRemoveForm(
                            state: .init(
                                action: "/admin/media/processors/remove/",
                                page: page,
                                search: "",
                                canRemove: canRemove,
                                buttonTitle: "Remove selected"
                            ),
                            table: context.render(
                                ListTableShell(
                                    table: Table {
                                        Thead {
                                            Tr {
                                                if canRemove {
                                                    context.render(
                                                        ListTableSelectAllCheckbox()
                                                    )
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
                                                        context.render(
                                                            ListTableRowSelectCheckbox(
                                                                state: .init(
                                                                    id: item.id
                                                                )
                                                            )
                                                        )
                                                    }
                                                    Td(item.name)
                                                        .data(
                                                            "label",
                                                            "File suffix"
                                                        )
                                                        .columnWidth(
                                                            percent: 50
                                                        )
                                                    Td(item.matchExtensions)
                                                        .data(
                                                            "label",
                                                            "Match extensions"
                                                        )
                                                        .columnWidth(
                                                            percent: 50
                                                        )
                                                    context.render(
                                                        ListTableRowActions(
                                                            state: .init(
                                                                label:
                                                                    "Actions",
                                                                actions: [
                                                                    .init(
                                                                        title:
                                                                            "Details",
                                                                        href:
                                                                            "/admin/media/processors/\(item.id)/",
                                                                        className:
                                                                            nil,
                                                                        permission:
                                                                            "media:processors:read"
                                                                    ),
                                                                    .init(
                                                                        title:
                                                                            "Edit",
                                                                        href:
                                                                            "/admin/media/processors/\(item.id)/edit/",
                                                                        className:
                                                                            "edit",
                                                                        permission:
                                                                            "media:processors:update"
                                                                    ),
                                                                    .init(
                                                                        title:
                                                                            "Remove",
                                                                        href:
                                                                            "/admin/media/processors/\(item.id)/remove/",
                                                                        className:
                                                                            "delete",
                                                                        permission:
                                                                            "media:processors:delete"
                                                                    ),
                                                                ],
                                                                permissions:
                                                                    permissions
                                                            )
                                                        )
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    .class("cms-table", "action-table")
                                    .if(canRemove) { $0.class("select-table") }
                                )
                            )
                        )
                    )
                }
                context.render(
                    ListTablePagination(
                        state: .init(
                            path: "/admin/media/processors/",
                            page: page,
                            pageSize: pageSize,
                            total: total,
                            search: ""
                        )
                    )
                )
            }
        }
        .class("cms-section")
    }
}
