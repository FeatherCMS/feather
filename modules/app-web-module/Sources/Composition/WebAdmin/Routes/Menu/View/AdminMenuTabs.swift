import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import Builders
import Components

struct AdminMenuTabs: Component {
    enum Tab: Equatable {
        case details
        case items
    }

    let menuID: String
    let active: Tab

    var links: [AdminTabBar.Link] {
        let base = MenuRoutes.details(RouterPath(menuID)).description
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

    func html(context: inout BuilderContext) -> Div {
        context.build(AdminTabBar(links: links))
    }
}
