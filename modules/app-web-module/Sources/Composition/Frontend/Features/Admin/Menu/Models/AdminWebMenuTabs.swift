import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct AdminWebMenuTabs: Leaf {
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

    func renderHTML() -> Div {
        return AdminPillTabs(links: links).renderHTML()
    }
}
