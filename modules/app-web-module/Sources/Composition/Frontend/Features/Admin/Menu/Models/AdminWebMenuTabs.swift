import FeatherAdmin
import HTML
import SGML
import WebStandards

struct AdminWebMenuTabs: Component, FlowContent {
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

    func content() -> some BasicTag {
        AdminPillTabs(links: links).content()
    }
}
