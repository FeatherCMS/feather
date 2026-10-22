import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebAdminAPI
import Builders
import Components
import WebModule

struct MenuItemRow: Component {
    let menuId: String
    let item: Components.Schemas.MenuItemQueryItemSchema
    let permissions: AdminListActions
    let canReorder: Bool
    let returnTo: String

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(WebModule.Permissions.MenuItems.delete) {
                context.build(AdminListRowCheckbox(id: item.id))
            }
            if canReorder {
                Td {
                    Div {
                        Span("⠿").class("web-menu-item-drag")
                        Div {
                            Button("↑").type(.button)
                                .class(
                                    "button",
                                    "secondary-ghost",
                                    "row-button"
                                )
                                .data("web-menu-item-move", "up")
                                .ariaLabel("Move \(item.label) up")
                            Button("↓").type(.button)
                                .class(
                                    "button",
                                    "secondary-ghost",
                                    "row-button"
                                )
                                .data("web-menu-item-move", "down")
                                .ariaLabel("Move \(item.label) down")
                        }
                        .class("web-menu-item-actions")
                    }
                    .class("web-menu-item-reorder-cell")
                }
            }
            Td(item.label).data("label", "Label")
            Td(item.url).data("label", "URL")
            Td {
                context.build(
                    AdminChip(
                        label: item.isBlank ? "New tab" : "Same tab",
                        color: item.isBlank ? .green : .blue
                    )
                )
            }
            .data("label", "Target")
            context.build(
                AdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init(
                            "View",
                            href:
                                MenuItemRoutes.details(
                                    RouterPath(menuId),
                                    RouterPath(item.id)
                                )
                                .description,
                            style: .ghost(.primary),
                            permission: WebModule.Permissions.MenuItems.read
                        ),
                        .init(
                            "Edit",
                            href:
                                MenuItemRoutes.edit(
                                    RouterPath(menuId),
                                    RouterPath(item.id)
                                )
                                .description,
                            style: .ghost(.secondary),
                            permission: WebModule.Permissions.MenuItems.update
                        ),
                    ],
                    permissions: permissions
                )
            )
        }
        .class("web-menu-item-row")
        .data("web-menu-item", item.id)
        .data(
            "web-menu-item-move-url",
            MenuItemRoutes.move(RouterPath(menuId), RouterPath(item.id))
                .description
        )
    }
}
