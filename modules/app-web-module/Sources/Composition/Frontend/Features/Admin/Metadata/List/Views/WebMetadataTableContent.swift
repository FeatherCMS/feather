import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebContracts

struct WebMetadataTableContent: Component {
    let metadata: [Components.Schemas.WebMetadataListItemSchema]
    let permissions: NewAdminListActions
    let pageState: NewAdminListPageState
    let search: String?
    let referenceType: String?
    let referenceTypeOptions: [WebMetadataReferenceTypeOption]

    private var searchValue: String { search ?? "" }
    private var referenceTypeValue: String { referenceType ?? "" }

    func html(context: inout BuilderContext) -> Div {
        let hasActiveQuery = !searchValue.isEmpty || !referenceTypeValue.isEmpty

        return context.build(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: WebMetadataRoutes.list.description
                            )
                        )
                    }
                    else if metadata.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                NewAdminListNoResultsState(
                                    message:
                                        "No metadata matches the selected filters.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            NewAdminButton(
                                                "Reset filters",
                                                href: WebMetadataRoutes.list
                                                    .description,
                                                style: .secondary
                                            )
                                        )
                                    }
                                )
                            )
                        }
                        else {
                            context.build(
                                NewAdminListEmptyState(
                                    message: "No metadata yet.",
                                    icon: FeatherIcons.inbox()
                                )
                            )
                        }
                    }
                    else {
                        context.build(
                            NewAdminListShell(
                                layout: .init(
                                    name: "web-metadata",
                                    columns: [
                                        .fraction(2), .fraction(1), .fixed(120),
                                        .fixed(140), .fixed(140), .fixed(220),
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
                                        for item in metadata {
                                            context.build(
                                                WebMetadataRow(
                                                    metadata: item,
                                                    permissions: permissions
                                                )
                                            )
                                        }
                                    }
                                }
                                .class("cms-table", "action-table")
                            )
                        )
                    }
                },
                search: {
                    context.build(
                        NewAdminListSearch(
                            state: .init(
                                action: WebMetadataRoutes.list.description,
                                placeholder: "Quick search metadata",
                                search: searchValue
                            )
                        ) {
                            Select {
                                Option("All reference types")
                                    .value("")
                                    .if(referenceTypeValue.isEmpty) {
                                        $0.selected()
                                    }
                                for option in referenceTypeOptions {
                                    Option(option.title)
                                        .value(option.value)
                                        .if(referenceTypeValue == option.value)
                                    { $0.selected() }
                                }
                            }
                            .name("referenceType")
                            .ariaLabel("Reference type")
                        }
                    )
                },
                pagination: {
                    context.build(
                        NewAdminListPagination(
                            state: .init(
                                path: WebMetadataRoutes.list.description,
                                pageState: pageState,
                                search: searchValue,
                                queryItems: [
                                    .init(
                                        name: "referenceType",
                                        value: referenceTypeValue
                                    )
                                ]
                            )
                        )
                    )
                }
            )
        )
    }
}
