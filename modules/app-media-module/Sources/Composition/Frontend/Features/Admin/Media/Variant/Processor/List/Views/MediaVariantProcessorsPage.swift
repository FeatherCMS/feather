import FeatherAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import SGML
import WebBuilders
import WebComponents

struct MediaVariantProcessorsPage: Component {
    let variantId: String
    let processors: [MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema]
    let pageState: NewAdminListPageState
    let search: String?
    let permissions: NewAdminListActions

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: MediaVariantRoutes.breadcrumb))
            context.build(NewAdminPageHeader(state: .init(
                title: "Processors",
                description: "Manage the processors used by this media variant."
            )))
            context.build(AdminMediaVariantTabs(id: variantId, active: .processors))
            context.build(MediaVariantProcessorsTableContent(
                variantId: variantId,
                processors: processors,
                pageState: pageState,
                search: search,
                permissions: permissions,
            ))
        }
        .class("cms-section")
    }
}

struct MediaVariantProcessorsTableContent: Component {
    let variantId: String
    let processors: [MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema]
    let pageState: NewAdminListPageState
    let search: String?
    let permissions: NewAdminListActions

    func html(context: inout BuilderContext) -> Div {
        let canDelete = permissions.allows(MediaPermissions.VariantProcessors.delete)
        let hasActiveQuery = !(search?.isEmpty ?? true)
        let returnTo = NewAdminLocation.url(
            path: MediaVariantRoutes.processors(RouterPath(variantId)).description,
            page: pageState.page,
            search: search
        )
        return context.build(NewAdminList(
            table: {
                if pageState.isPageOutOfRange {
                    context.build(NewAdminListInvalidPageState(
                        pageState: pageState,
                        path: MediaVariantRoutes.processors(RouterPath(variantId)).description
                    ))
                }
                else if processors.isEmpty {
                    if hasActiveQuery {
                        context.build(NewAdminListNoResultsState(
                            message: "No processors match your search.",
                            icon: FeatherIcons.inbox(),
                            action: { context.build(NewAdminButton(
                                "Reset search",
                                href: MediaVariantRoutes.processors(RouterPath(variantId)).description,
                                style: .secondary
                            )) }
                        ))
                    }
                    else {
                        context.build(NewAdminListEmptyState(
                            message: "No processors configured yet.",
                            icon: FeatherIcons.inbox()
                        ))
                    }
                }
                else {
                    context.build(NewAdminListSelectionForm(
                        state: .init(
                            action: NewAdminLocation.remove(
                                path: MediaVariantRoutes.processorRemove(RouterPath(variantId)).description,
                                ids: [],
                                returnTo: returnTo
                            ),
                            pageState: pageState,
                            search: search ?? "",
                            button: .init("Remove selected", style: .destructive),
                            isEnabled: canDelete
                        ),
                        table: context.build(NewAdminListShell(
                            layout: .init(name: "media-variant-processors", columns: [.fraction(1), .fraction(2), .fraction(2), .fraction(3), .fraction(1), .fixed(220)]),
                            hasSelection: canDelete,
                            table: Table {
                                Thead {
                                    Tr {
                                        if canDelete { context.build(NewAdminListSelectAllCheckbox()) }
                                        Th("ID")
                                        Th("Name")
                                        Th("Input extensions")
                                        Th("Command template")
                                        Th("Active")
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for processor in processors {
                                        context.build(MediaVariantProcessorRow(
                                            variantId: variantId,
                                            processor: processor,
                                            permissions: permissions,
                                            returnTo: returnTo
                                        ))
                                    }
                                }
                            }.class("cms-table", "action-table").if(canDelete) { $0.class("select-table") }
                        ))
                    ))
                }
            },
            search: {
                context.build(NewAdminListSearch(state: .init(
                    action: MediaVariantRoutes.processors(RouterPath(variantId)).description,
                    placeholder: "Quick search processors",
                    search: search ?? ""
                )))
            },
            toolbar: {
                if permissions.allows(MediaPermissions.VariantProcessors.create) {
                    context.build(NewAdminListToolbar {
                        context.build(NewAdminButton("Add new", href: MediaVariantRoutes.processorAdd(RouterPath(variantId)).description))
                    })
                }
            },
            pagination: {
                context.build(NewAdminListPagination(state: .init(
                    path: MediaVariantRoutes.processors(RouterPath(variantId)).description,
                    pageState: pageState,
                    search: search ?? ""
                )))
            }
        ))
    }
}

struct MediaVariantProcessorRow: Component {
    let variantId: String
    let processor: MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema
    let permissions: NewAdminListActions
    let returnTo: String

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(MediaPermissions.VariantProcessors.delete) {
                context.build(NewAdminListRowCheckbox(id: processor.id))
            }
            Td(processor.id).data("label", "ID")
            Td(processor.name).data("label", "Name")
            Td(processor.matchExtensions).data("label", "Input extensions")
            Td(processor.commandTemplate).data("label", "Command template")
            Td(processor.isActive ? "Yes" : "No").data("label", "Active")
            context.build(NewAdminListRowActions(
                label: "Actions",
                actions: [
                    .init("Edit", href: MediaVariantRoutes.processorEdit(RouterPath(variantId), processorId: RouterPath(processor.id)).description, style: .ghost(.primary), permission: MediaPermissions.VariantProcessors.update),
                    .init("Remove", href: NewAdminLocation.remove(
                        path: MediaVariantRoutes.processorRemove(RouterPath(variantId)).description,
                        ids: [processor.id],
                        returnTo: returnTo
                    ), style: .destructive, permission: MediaPermissions.VariantProcessors.delete)
                ],
                permissions: permissions
            ))
        }
    }
}
