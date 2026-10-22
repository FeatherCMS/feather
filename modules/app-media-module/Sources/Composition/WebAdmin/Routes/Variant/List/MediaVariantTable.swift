import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import SGML
import WebBuilders
import WebComponents

struct MediaVariantTable: Component {
    struct State {
        let permissions: AdminListActions
        let variants:
            [MediaAdminAPI.Components.Schemas.MediaVariantQueryItemSchema]
        let pageState: AdminListPageState
        let search: String?
        let routes: Variant.Router.Routes
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(links: state.routes.breadcrumb)
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
                    search: state.search,
                    routes: state.routes
                )
            )
        }
        .class("cms-section")
    }
    }

    struct MediaVariantTableContent: Component {
    let variants: [MediaAdminAPI.Components.Schemas.MediaVariantQueryItemSchema]
    let permissions: AdminListActions
    let pageState: AdminListPageState
    let search: String?
    let routes: Variant.Router.Routes

    private var returnTo: String {
        AdminLocation.url(
            path: routes.list.path,
            page: pageState.page,
            search: search
        )
    }

    func html(context: inout BuilderContext) -> Div {
        let canDelete = permissions.allows(Variant.Permissions.delete)
        let hasActiveQuery = !(search?.isEmpty ?? true)
        return context.build(
            AdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            AdminListInvalidPageState(
                                pageState: pageState,
                                path: routes.list.path
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
                                                href: routes.list.path,
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
                                            Variant.Permissions.create
                                        ) {
                                            context.build(
                                                AdminButton(
                                                    "Add new",
                                                    href: routes.add.path
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
                                        path: routes.remove.path,
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
                                action: routes.list.path,
                                placeholder: "Quick search media variants",
                                search: search ?? ""
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(Variant.Permissions.create) {
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
                                        "Add new",
                                        href: routes.add.path
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
                                path: routes.list.path,
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
    let variant: MediaAdminAPI.Components.Schemas.MediaVariantQueryItemSchema
    let permissions: AdminListActions
    let returnTo: String
    let routes: Variant.Router.Routes

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(Variant.Permissions.delete) {
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
                                routes.editPath(variant.id),
                            style: .ghost(.primary),
                            permission: Variant.Permissions.update
                        )
                    ],
                    permissions: permissions
                )
            )
        }
    }
}
