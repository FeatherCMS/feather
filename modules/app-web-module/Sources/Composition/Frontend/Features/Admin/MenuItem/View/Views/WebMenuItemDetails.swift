import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct WebMenuItemDetails: Component {
    struct State {
        let item: WebMenuItemDetailsModel
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .init(
                        title: "Item details",
                        description: "Review the navigation menu link."
                    ),
                    fields: [
                        .init(label: "ID", value: state.item.id),
                        .init(label: "Label", value: state.item.label),
                        .init(label: "URL", value: state.item.url),
                        .init(
                            label: "Priority",
                            value: "\(state.item.priority)"
                        ),
                        .init(
                            label: "Blank target",
                            value: state.item.isBlank ? "Yes" : "No"
                        ),
                        .init(
                            label: "Permission",
                            value: state.item.permission
                        ),
                        .init(
                            label: "Authentication",
                            value: state.item.authentication
                        ),
                        .init(label: "Notes", value: state.item.notes ?? "—"),
                    ],
                    actions: [
                        .init(
                            label: "Edit item",
                            href:
                                WebMenuItemRoutes.edit(
                                    RouterPath(state.item.menuId),
                                    RouterPath(state.item.id)
                                )
                                .description,
                            style: .primary
                        ),
                        .init(
                            label: "Remove item",
                            href:
                                WebMenuItemRoutes.details(
                                    RouterPath(state.item.menuId),
                                    RouterPath(state.item.id)
                                )
                                .appendingPath(RouterPath("remove"))
                                .description,
                            style: .destructive
                        ),
                    ]
                )
            )
        }
        .class("cms-section")
    }
}
