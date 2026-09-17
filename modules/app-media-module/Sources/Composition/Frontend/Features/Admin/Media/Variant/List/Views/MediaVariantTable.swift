import FeatherAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import SGML
import WebBuilders
import WebComponents

struct MediaVariantTable: Component {
    struct State {
        let permissions: NewAdminListActions
        let variants: [MediaAdminAPI.Components.Schemas.MediaVariantListItemSchema]
        let pageState: NewAdminListPageState
        let search: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: MediaVariantRoutes.breadcrumb))
            context.build(NewAdminPageHeader(state: .init(
                title: "Media variants",
                description: "Manage reusable media outputs and their processors."
            )))
            context.build(MediaVariantTableContent(
                variants: state.variants,
                permissions: state.permissions,
                pageState: state.pageState,
                search: state.search
            ))
        }
        .class("cms-section")
    }
}

struct MediaVariantTableContent: Component {
    let variants: [MediaAdminAPI.Components.Schemas.MediaVariantListItemSchema]
    let permissions: NewAdminListActions
    let pageState: NewAdminListPageState
    let search: String?

    private var returnTo: String {
        NewAdminLocation.url(path: MediaVariantRoutes.list.description, page: pageState.page, search: search)
    }

    func html(context: inout BuilderContext) -> Div {
        let canDelete = permissions.allows(MediaPermissions.Variants.delete)
        let hasActiveQuery = !(search?.isEmpty ?? true)
        return context.build(NewAdminList(
            table: {
                if pageState.isPageOutOfRange {
                    context.build(NewAdminListInvalidPageState(
                        pageState: pageState,
                        path: MediaVariantRoutes.list.description
                    ))
                }
                else if variants.isEmpty {
                    if hasActiveQuery {
                        context.build(NewAdminListNoResultsState(
                            message: "No media variants match your search.",
                            icon: FeatherIcons.inbox(),
                            action: { context.build(NewAdminButton(
                                "Reset search",
                                href: MediaVariantRoutes.list.description,
                                style: .secondary
                            )) }
                        ))
                    }
                    else {
                        context.build(NewAdminListEmptyState(
                            message: "No media variants yet.",
                            icon: FeatherIcons.inbox(),
                            action: {
                                if permissions.allows(MediaPermissions.Variants.create) {
                                    context.build(NewAdminButton(
                                        "Add new",
                                        href: MediaVariantRoutes.add.description
                                    ))
                                }
                            }
                        ))
                    }
                }
                else {
                    context.build(NewAdminListSelectionForm(
                        state: .init(
                            action: NewAdminLocation.remove(
                                path: MediaVariantRoutes.remove.description,
                                ids: [],
                                returnTo: returnTo
                            ),
                            pageState: pageState,
                            search: search ?? "",
                            button: .init("Remove selected", style: .destructive),
                            isEnabled: canDelete
                        ),
                        table: context.build(NewAdminListShell(
                            layout: .init(
                                name: "media-variants",
                                columns: [.fraction(1), .fraction(2), .fraction(2), .fraction(1), .fraction(1), .fixed(220)]
                            ),
                            hasSelection: canDelete,
                            table: Table {
                                Thead {
                                    Tr {
                                        if canDelete { context.build(NewAdminListSelectAllCheckbox()) }
                                        Th("ID")
                                        Th("Key")
                                        Th("Name")
                                        Th("Required")
                                        Th("Active")
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for variant in variants {
                                        context.build(MediaVariantRow(
                                            variant: variant,
                                            permissions: permissions,
                                            returnTo: returnTo
                                        ))
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canDelete) { $0.class("select-table") }
                        ))
                    ))
                }
            },
            search: {
                context.build(NewAdminListSearch(state: .init(
                    action: MediaVariantRoutes.list.description,
                    placeholder: "Quick search media variants",
                    search: search ?? ""
                )))
            },
            toolbar: {
                if permissions.allows(MediaPermissions.Variants.create) {
                    context.build(NewAdminListToolbar {
                        context.build(NewAdminButton("Add new", href: MediaVariantRoutes.add.description))
                    })
                }
            },
            pagination: {
                context.build(NewAdminListPagination(state: .init(
                    path: MediaVariantRoutes.list.description,
                    pageState: pageState,
                    search: search ?? ""
                )))
            }
        ))
    }
}

struct MediaVariantRow: Component {
    let variant: MediaAdminAPI.Components.Schemas.MediaVariantListItemSchema
    let permissions: NewAdminListActions
    let returnTo: String

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(MediaPermissions.Variants.delete) {
                context.build(NewAdminListRowCheckbox(id: variant.id))
            }
            Td(variant.id).data("label", "ID")
            Td(variant.key).data("label", "Key")
            Td(variant.name).data("label", "Name")
            Td(variant.isRequired ? "Yes" : "No").data("label", "Required")
            Td(variant.isActive ? "Yes" : "No").data("label", "Active")
            context.build(NewAdminListRowActions(
                label: "Actions",
                actions: [
                    .init("Edit", href: MediaVariantRoutes.edit(RouterPath(variant.id)).description, style: .ghost(.primary), permission: MediaPermissions.Variants.update),
                    .init("Remove", href: NewAdminLocation.remove(
                        path: MediaVariantRoutes.remove.description,
                        ids: [variant.id],
                        returnTo: returnTo
                    ), style: .destructive, permission: MediaPermissions.Variants.delete)
                ],
                permissions: permissions
            ))
        }
    }
}
