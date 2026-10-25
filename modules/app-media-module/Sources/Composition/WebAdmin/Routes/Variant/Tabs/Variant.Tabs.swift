import FeatherWebAdmin
import HTML
import Hummingbird
import MediaModule
import WebComponents

extension Variant {
    struct Tabs: Component {
        enum Tab: Equatable {
            case details
            case processors
        }

        let id: String
        let active: Tab
        let routes: Router.Routes

        var links: [AdminTabBar.Link] {
            [
                .init(
                    label: "Details",
                    href: routes.editPath(id),
                    isCurrent: active == .details
                ),
                .init(
                    label: "Processors",
                    href: routes.processorPath(id),
                    isCurrent: active == .processors
                ),
            ]
        }

        func html(context: inout BuilderContext) -> Div {
            context.build(AdminTabBar(links: links))
        }
    }
}
