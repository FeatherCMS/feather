import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct AdminWebMenuTabs: Component {
    enum Tab: Equatable {
        case details
        case items
    }

    let menuID: String
    let active: Tab

    var links: [AdminPillTabs.Link] {
        let base = "/admin/web/menus/\(menuID)"
        return [
            .init(
                label: "Details",
                href: base + "/edit/",
                isCurrent: active == .details
            ),
            .init(
                label: "Items",
                href: base + "/items/",
                isCurrent: active == .items
            ),
        ]
    }

    func html(context: inout RenderContext) -> Div {
        return context.render(AdminPillTabs(links: links))
    }
}
