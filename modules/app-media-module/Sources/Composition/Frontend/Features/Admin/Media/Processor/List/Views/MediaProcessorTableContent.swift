import FeatherAdmin
import FeatherContracts
import HTML
import MediaAdminAPI
import MediaContracts
import SGML
import WebBuilders
import WebComponents

struct MediaProcessorTableContent: Component {
    let items: [Components.Schemas.MediaProcessorListItemSchema]
    let permissions: NewAdminListActions
    let pageState: NewAdminListPageState
    let search: String?

    private var searchValue: String {
        search ?? ""
    }

    private var returnTo: String {
        NewAdminLocation.url(
            path: MediaProcessorRoutes.list.description,
            page: pageState.page,
            search: search
        )
    }

    func html(context: inout RenderContext) -> Div {
        let canDelete = permissions.allows(MediaPermissions.Processors.delete)
        let hasActiveQuery = !(search?.isEmpty ?? true)

        return context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: MediaProcessorRoutes.list.description
                            )
                        )
                    }
                    else if items.isEmpty {
                        if hasActiveQuery {
                            context.render(
                                NewAdminListNoResultsState(
                                    message:
                                        "No media processors match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.render(
                                            NewAdminButton(
                                                "Reset search",
                                                href: MediaProcessorRoutes.list
                                                    .description,
                                                style: .secondary
                                            )
                                        )
                                    }
                                )
                            )
                        }
                        else {
                            context.render(
                                NewAdminListEmptyState(
                                    message: "No media processors yet.",
                                    icon: FeatherIcons.settings(),
                                    action: {
                                        if permissions.allows(
                                            MediaPermissions.Processors.create
                                        ) {
                                            context.render(
                                                NewAdminButton(
                                                    "Add new",
                                                    href: MediaProcessorRoutes
                                                        .add
                                                        .description
                                                )
                                            )
                                        }
                                    }
                                )
                            )
                        }
                    }
                    else {
                        context.render(
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: NewAdminLocation.remove(
                                        path: MediaProcessorRoutes.remove
                                            .description,
                                        ids: [],
                                        returnTo: returnTo
                                    ),
                                    pageState: pageState,
                                    search: searchValue,
                                    button: .init(
                                        "Remove selected",
                                        style: .destructive
                                    ),
                                    isEnabled: canDelete
                                ),
                                table: context.render(
                                    NewAdminListShell(
                                        layout: .init(
                                            name: "media-processors",
                                            columns: [
                                                .fraction(1),
                                                .fraction(2),
                                                .fixed(240),
                                            ]
                                        ),
                                        hasSelection: canDelete,
                                        table: Table {
                                            Thead {
                                                Tr {
                                                    if canDelete {
                                                        context.render(
                                                            NewAdminListSelectAllCheckbox()
                                                        )
                                                    }
                                                    Th("File suffix")
                                                    Th("Match extensions")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for item in items {
                                                    context.render(
                                                        MediaProcessorRow(
                                                            state: .init(
                                                                item: item,
                                                                returnTo:
                                                                    returnTo
                                                            ),
                                                            permissions:
                                                                permissions
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
                    context.render(
                        NewAdminListSearch(
                            state: .init(
                                action: MediaProcessorRoutes.list.description,
                                placeholder: "Quick search media processors",
                                search: searchValue
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(MediaPermissions.Processors.create) {
                        context.render(
                            NewAdminListToolbar {
                                context.render(
                                    NewAdminButton(
                                        "Add new",
                                        href: MediaProcessorRoutes.add
                                            .description
                                    )
                                )
                            }
                        )
                    }
                },
                pagination: {
                    context.render(
                        NewAdminListPagination(
                            state: .init(
                                path: MediaProcessorRoutes.list.description,
                                pageState: pageState,
                                search: searchValue
                            )
                        )
                    )
                }
            )
        )
    }
}
