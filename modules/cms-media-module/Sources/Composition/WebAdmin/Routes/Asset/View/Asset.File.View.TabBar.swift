import FeatherWebAdmin
import HTML
import MediaModule
import SGML
import WebBuilders
import WebComponents

extension Asset.File.View {
    struct TabBar: Component {
        enum Tab: String, Equatable {
            case details
            case variants
        }

        let active: Tab
        let detailsPath: String
        let variantsPath: String

        var links: [AdminTabBar.Link] {
            [
                .init(
                    label: "Details",
                    href: detailsPath,
                    isCurrent: active == .details
                ),
                .init(
                    label: "Variants",
                    href: variantsPath,
                    isCurrent: active == .variants
                ),
            ]
        }

        func html(context: inout BuilderContext) -> Div {
            context.build(AdminTabBar(links: links))
        }
    }
}
