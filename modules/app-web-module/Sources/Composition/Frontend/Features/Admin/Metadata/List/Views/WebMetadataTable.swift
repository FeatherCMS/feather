import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import Hummingbird
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebContracts

struct WebMetadataTable: Component {
    struct State {
        let isEdited: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let rules: [Components.Schemas.WebMetadataListItemSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let referenceTypeOptions: [WebMetadataReferenceTypeOption]
        let search: String
        let referenceType: String
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
                WebPermissions.Metadata.allPermissions().filter {
                    state.permissions.contains($0.rawValue)
                }
            )
        )
    }

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Metadata",
                        description: "Manage search and sharing metadata for web pages."
                    )
                )
            )
            if !state.canAccess {
                context.render(
                    NewAdminStatusView(
                        state: .init(title: state.deniedInfo, message: state.deniedMessage),
                        icon: FeatherIcons.lock()
                    )
                )
            }
            else {
                if state.isEdited { P("Web metadata edited successfully.") }
                context.render(
                    NewAdminList(
                        table: {
                            if pageState.isPageOutOfRange {
                                context.render(
                                    NewAdminListInvalidPageState(
                                        pageState: pageState,
                                        path: WebMetadataRoutes.list.description
                                    )
                                )
                            }
                            else if state.rules.isEmpty {
                                if state.search.isEmpty && state.referenceType.isEmpty {
                                    context.render(
                                        NewAdminListEmptyState(
                                            message: "No metadata yet.",
                                            icon: FeatherIcons.inbox()
                                        )
                                    )
                                }
                                else {
                                    context.render(
                                        NewAdminListNoResultsState(
                                            message: "No metadata matches the selected filters.",
                                            icon: FeatherIcons.inbox(),
                                            action: {
                                                context.render(
                                                    NewAdminButton(
                                                        "Reset filters",
                                                        href: WebMetadataRoutes.list.description,
                                                        style: .secondary
                                                    )
                                                )
                                            }
                                        )
                                    )
                                }
                            }
                            else {
                                context.render(
                                    NewAdminListShell(
                                        layout: .init(
                                            name: "web-metadata",
                                            columns: [
                                                .fraction(2),
                                                .fraction(1),
                                                .fixed(120),
                                                .fixed(140),
                                                .fixed(140),
                                                .fixed(220),
                                            ]
                                        ),
                                        table: Table {
                                            Thead {
                                                Tr {
                                                    Th("Slug")
                                                    Th("Reference type")
                                                    Th("Status")
                                                    Th("Publication")
                                                    Th("Expiration")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for rule in state.rules {
                                                    Tr {
                                                        Td(rule.slug).data("label", "Slug")
                                                        Td(rule.referenceType ?? "—").data("label", "Reference type")
                                                        Td(rule.status.capitalized).data("label", "Status")
                                                        Td(format(rule.publicationDate)).data("label", "Publication")
                                                        Td(format(rule.expirationDate)).data("label", "Expiration")
                                                        context.render(
                                                            NewAdminListRowActions(
                                                                label: "Actions",
                                                                actions: [
                                                                    .init("View", href: WebMetadataRoutes.details(RouterPath(rule.id)).description, style: .ghost(.primary), permission: WebPermissions.Metadata.read),
                                                                    .init("Edit", href: WebMetadataRoutes.edit(RouterPath(rule.id)).description, style: .ghost(.secondary), permission: WebPermissions.Metadata.update),
                                                                ],
                                                                permissions: actions
                                                            )
                                                        )
                                                    }
                                                }
                                            }
                                        }
                                        .class("cms-table", "action-table")
                                    )
                                )
                            }
                        },
                        search: {
                            context.render(
                                NewAdminListSearch(
                                    state: .init(
                                        action: WebMetadataRoutes.list.description,
                                        placeholder: "Quick search metadata",
                                        search: state.search,
                                        queryItems: []
                                    )
                                ) {
                                    Select {
                                        Option("All reference types")
                                            .value("")
                                            .if(state.referenceType.isEmpty) { $0.selected() }
                                        for option in state.referenceTypeOptions {
                                            Option(option.title)
                                                .value(option.value)
                                                .if(state.referenceType == option.value) { $0.selected() }
                                        }
                                    }
                                    .name("referenceType")
                                    .ariaLabel("Reference type")
                                }
                            )
                        },
                        pagination: {
                            context.render(
                                NewAdminListPagination(
                                    state: .init(
                                        path: WebMetadataRoutes.list.description,
                                        pageState: pageState,
                                        search: state.search,
                                        queryItems: [
                                            .init(name: "referenceType", value: state.referenceType)
                                        ]
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

    private func format(_ timestamp: Double?) -> String {
        guard let timestamp else { return "—" }
        return DateFormatting.formatUnixTimestamp(timestamp)
    }
}
