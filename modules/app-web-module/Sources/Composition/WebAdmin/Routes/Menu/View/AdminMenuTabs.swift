import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AdminMenuTabs: Component {
    enum Tab: Equatable {
        case details
        case items
    }

    let active: Tab
    let detailsPath: String
    let itemsPath: String

    var links: [AdminTabBar.Link] {
        [
            .init(
                label: "Details",
                href: detailsPath,
                isCurrent: active == .details
            ),
            .init(
                label: "Items",
                href: itemsPath,
                isCurrent: active == .items
            ),
        ]
    }

    func html(context: inout BuilderContext) -> Div {
        context.build(AdminTabBar(links: links))
    }
}
