import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import SGML
import WebBuilders
import WebComponents

struct MediaVariantProcessorsTableContent: Component {
    let variantId: String
    let processors:
        [MediaAdminAPI.Components.Schemas.MediaVariantProcessorQueryItemSchema]
    let pageState: AdminListPageState
    let search: String?
    let permissions: AdminListActions
    let routes: Variant.Router.Routes

    func html(context: inout BuilderContext) -> Div {
        let canDelete = permissions.allows(
            Variant.Processor.Permissions.delete
        )
        let hasActiveQuery = !(search?.isEmpty ?? true)
        let returnTo = AdminLocation.url(
            path: routes.processorPath(variantId),
            page: pageState.page,
            search: search
        )
        return context.build(
            AdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            AdminListInvalidPageState(
                                pageState: pageState,
                                path: routes.processorPath(variantId)
                            )
                        )
                    }
                    else if processors.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                AdminListNoResultsState(
                                    message: "No processors match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            AdminButton(
                                                "Reset search",
                                                href: routes.processorPath(
                                                    variantId
                                                ),
                                                style: .secondary
                                            )
                                        )
                                    }
                                )
                            )
                        }
                        else {
                            context.build(
                                AdminListEmptyState(
                                    message: "No processors configured yet.",
                                    icon: FeatherIcons.inbox()
                                )
                            )
                        }
                    }
                    else {
                        context.build(
                            AdminListSelectionForm(
                                state: .init(
                                    action: AdminLocation.remove(
                                        path: routes.processorRemovePath(
                                            variantId
                                        ),
                                        ids: [],
                                        returnTo: returnTo
                                    ),
                                    pageState: pageState,
                                    search: search ?? "",
                                    button: .init(
                                        "Remove selected",
                                        style: .destructive
                                    ),
                                    isEnabled: canDelete
                                ),
                                table: context.build(
                                    AdminListShell(
                                        layout: .init(
                                            name: "media-variant-processors",
                                            columns: [
                                                .fraction(2), .fraction(2),
                                                .fraction(3), .fraction(1),
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
                                                    Th("Name")
                                                    Th("Input extensions")
                                                    Th("Command template")
                                                    Th("Active")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for processor in processors {
                                                    context.build(
                                                        MediaVariantProcessorRow(
                                                            variantId:
                                                                variantId,
                                                            processor:
                                                                processor,
                                                            permissions:
                                                                permissions,
                                                            returnTo: returnTo,
                                                            routes: routes
                                                        )
                                                    )
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
                                action: routes.processorPath(variantId),
                                placeholder: "Quick search processors",
                                search: search ?? ""
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(
                        Variant.Processor.Permissions.create
                    ) {
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
                                        "Add new",
                                        href: routes.processorAddPath(variantId)
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
                                path: routes.processorPath(variantId),
                                pageState: pageState,
                                search: search ?? ""
                            )
                        )
                    )
                }
            )
        )
    }
}
