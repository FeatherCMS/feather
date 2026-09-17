import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AdminMediaVariantTabs: Component {
    enum Tab: Equatable {
        case details
        case processors
    }

    let id: String
    let active: Tab

    var links: [NewAdminTabBar.Link] {
        [
            .init(
                label: "Details",
                href: MediaVariantRoutes.edit(RouterPath(id)).description,
                isCurrent: active == .details
            ),
            .init(
                label: "Processors",
                href: MediaVariantRoutes.processors(RouterPath(id)).description,
                isCurrent: active == .processors
            ),
        ]
    }

    func html(context: inout BuilderContext) -> Div {
        context.build(NewAdminTabBar(links: links))
    }
}
