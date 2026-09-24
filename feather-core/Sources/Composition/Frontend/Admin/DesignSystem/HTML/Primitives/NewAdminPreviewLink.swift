public import CSS
public import HTML
import SGML
import SVG
import WebBuilders
public import WebComponents

public struct NewAdminPreviewLink: Component {
    public let href: String
    public let label: String

    public init(
        href: String,
        label: String
    ) {
        self.href = href
        self.label = label
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("new-admin-preview-link") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Width(1.25.rem)
                Height(1.25.rem)
                MarginLeft(0.4.rem)
                VerticalAlign(.middle)
            }
        ]
    }

    public func html(context: inout BuilderContext) -> A {
        A {
            FeatherIcons.externalLink()
                .width(16)
                .height(16)
        }
        .href(href)
        .target(.blank)
        .ariaLabel(label)
        .class("new-admin-preview-link")
    }
}
