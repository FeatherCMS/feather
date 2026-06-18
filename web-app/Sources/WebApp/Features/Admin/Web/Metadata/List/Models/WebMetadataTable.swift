import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct WebMetadataTable: Component {

    struct State {
        let isEdited: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let rules: [Components.Schemas.WebMetadataListItemSchema]
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
                H1("Metadata entries")

                if state.isEdited { P("Web metadata edited successfully.") }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/web/metadata/",
                        placeholder: "Quick search metadata entries",
                        search: state.search
                    )
                )

                if state.rules.isEmpty {
                    P(
                        state.search.isEmpty
                            ? "No metadata entries yet."
                            : "No metadata entries match your search."
                    )
                }
                else {
                    ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    Th("Slug")
                                        .style("width:42%;min-width:20rem;")
                                    Th("Status")
                                        .style(
                                            "width:8%;min-width:6.5rem;white-space:nowrap;"
                                        )
                                    Th("Publication")
                                        .style(
                                            "width:12%;min-width:8.5rem;white-space:nowrap;"
                                        )
                                    Th("Expiration")
                                        .style(
                                            "width:12%;min-width:8.5rem;white-space:nowrap;"
                                        )
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for rule in state.rules {
                                    Tr {
                                        Td(rule.slug)
                                            .style("min-width:20rem;")
                                        Td(rule.status.capitalized)
                                            .style("white-space:nowrap;")
                                        Td(format(rule.publicationDate))
                                            .style("white-space:nowrap;")
                                        Td(format(rule.expirationDate))
                                            .style("white-space:nowrap;")
                                        ListTableRowActions(
                                            state: .init(
                                                label: "Actions",
                                                actions: [
                                                    .init(
                                                        title: "Details",
                                                        href:
                                                            "/admin/web/metadata/\(rule.id)/",
                                                        className: nil,
                                                        permission:
                                                            "web:metadata:read"
                                                    ),
                                                    .init(
                                                        title: "Edit",
                                                        href:
                                                            "/admin/web/metadata/\(rule.id)/edit/",
                                                        className: "edit",
                                                        permission:
                                                            "web:metadata:update"
                                                    ),
                                                ],
                                                permissions: state.permissions
                                            )
                                        )
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                    )
                    ListTablePagination(
                        state: .init(
                            path: "/admin/web/metadata/",
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

    private func format(
        _ timestamp: Double?
    ) -> String {
        guard let timestamp else {
            return "-"
        }
        return DateFormatting.formatUnixTimestamp(timestamp)
    }
}
