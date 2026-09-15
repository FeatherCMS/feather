import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AdminWebMenuTabs: Component {
    enum Tab: Equatable {
        case details
        case items
    }

    let menuID: String
    let active: Tab

    var links: [NewAdminTabBar.Link] {
        let base = WebMenuRoutes.details(RouterPath(menuID)).description
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
        context.build(NewAdminTabBar(links: links))
    }
}
