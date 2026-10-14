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
        let permissions: AdminListActions
        let variants:
            [MediaAdminAPI.Components.Schemas.MediaVariantListItemSchema]
        let pageState: AdminListPageState
        let search: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(links: MediaVariantRoutes.breadcrumb)
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Media variants",
                        description:
                            "Manage reusable media outputs and their processors."
                    )
                )
            )
            context.build(
                MediaVariantTableContent(
                    variants: state.variants,
                    permissions: state.permissions,
                    pageState: state.pageState,
                    search: state.search
                )
            )
        }
        .class("cms-section")
    }
}

struct MediaVariantTableContent: Component {
    let variants: [MediaAdminAPI.Components.Schemas.MediaVariantListItemSchema]
    let permissions: AdminListActions
    let pageState: AdminListPageState
    let search: String?

    private var returnTo: String {
        AdminLocation.url(
            path: MediaVariantRoutes.list.description,
            page: pageState.page,
            search: search
        )
    }

    func html(context: inout BuilderContext) -> Div {
        let canDelete = permissions.allows(MediaPermissions.Variants.delete)
        let hasActiveQuery = !(search?.isEmpty ?? true)
        return context.build(
            AdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            AdminListInvalidPageState(
                                pageState: pageState,
                                path: MediaVariantRoutes.list.description
                            )
                        )
                    }
                    else if variants.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                AdminListNoResultsState(
                                    message:
                                        "No media variants match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            AdminButton(
                                                "Reset search",
                                                href: MediaVariantRoutes.list
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
                                AdminListEmptyState(
                                    message: "No media variants yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if permissions.allows(
                                            MediaPermissions.Variants.create
                                        ) {
                                            context.build(
                                                AdminButton(
                                                    "Add new",
                                                    href: MediaVariantRoutes.add
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
                        context.build(
                            AdminListSelectionForm(
                                state: .init(
                                    action: AdminLocation.remove(
                                        path: MediaVariantRoutes.remove
                                            .description,
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
                                            name: "media-variants",
                                            columns: [
                                                .fraction(2), .fraction(2),
                                                .fraction(1), .fraction(1),
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
                                                    Th("Key")
                                                    Th("Name")
                                                    Th("Required")
                                                    Th("Active")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for variant in variants {
                                                    context.build(
                                                        MediaVariantRow(
                                                            variant: variant,
                                                            permissions:
                                                                permissions,
                                                            returnTo: returnTo
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
                                action: MediaVariantRoutes.list.description,
                                placeholder: "Quick search media variants",
                                search: search ?? ""
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(MediaPermissions.Variants.create) {
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
                                        "Add new",
                                        href: MediaVariantRoutes.add.description
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
                                path: MediaVariantRoutes.list.description,
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

struct MediaVariantRow: Component {
    let variant: MediaAdminAPI.Components.Schemas.MediaVariantListItemSchema
    let permissions: AdminListActions
    let returnTo: String

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(MediaPermissions.Variants.delete) {
                context.build(AdminListRowCheckbox(id: variant.id))
            }
            Td(variant.key)
                .data("label", "Key")
                .data("remove-label", "true")
            Td(variant.name).data("label", "Name")
            Td(variant.isRequired ? "Yes" : "No").data("label", "Required")
            Td(variant.isActive ? "Yes" : "No").data("label", "Active")
            context.build(
                AdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init(
                            "Edit",
                            href:
                                MediaVariantRoutes.edit(RouterPath(variant.id))
                                .description,
                            style: .ghost(.primary),
                            permission: MediaPermissions.Variants.update
                        ),
                    ],
                    permissions: permissions
                )
            )
        }
    }
}
