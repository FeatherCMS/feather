import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebContracts

struct WebMenuItemRow: Component {
    let menuId: String
    let item: Components.Schemas.WebMenuItemListItemSchema
    let permissions: NewAdminListActions
    let canReorder: Bool
    let returnTo: String

    func html(context: inout RenderContext) -> Tr {
        Tr {
            if permissions.allows(WebPermissions.MenuItems.delete) {
                context.render(NewAdminListRowCheckbox(id: item.id))
            }
            if canReorder {
                Td {
                    Div {
                        Span("⠿").class("web-menu-item-drag")
                        Div {
                            Button("↑").type(.button).class("row-btn", "edit").data("web-menu-item-move", "up").ariaLabel("Move \(item.label) up")
                            Button("↓").type(.button).class("row-btn", "edit").data("web-menu-item-move", "down").ariaLabel("Move \(item.label) down")
                        }.class("web-menu-item-actions")
                    }.class("web-menu-item-reorder-cell")
                }
            }
            Td(item.label).data("label", "Label")
            Td(item.url).data("label", "URL")
            Td(item.isBlank ? "Yes" : "No").data("label", "Blank")
            Td(item.permission).data("label", "Permission")
            context.render(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init("View", href: WebMenuItemRoutes.details(RouterPath(menuId), RouterPath(item.id)).description, style: .ghost(.primary), permission: WebPermissions.MenuItems.read),
                        .init("Edit", href: WebMenuItemRoutes.edit(RouterPath(menuId), RouterPath(item.id)).description, style: .ghost(.secondary), permission: WebPermissions.MenuItems.update),
                        .init("Remove", href: NewAdminLocation.remove(path: WebMenuItemRoutes.remove(RouterPath(menuId)).description, ids: [item.id], returnTo: returnTo), style: .destructive, permission: WebPermissions.MenuItems.delete),
                    ],
                    permissions: permissions
                )
            )
        }
        .class("web-menu-item-row")
        .data("web-menu-item", item.id)
        .data("web-menu-item-move-url", WebMenuItemRoutes.move(RouterPath(menuId), RouterPath(item.id)).description)
    }
}
