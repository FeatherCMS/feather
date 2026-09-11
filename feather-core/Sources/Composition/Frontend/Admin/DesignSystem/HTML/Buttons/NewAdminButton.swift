import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminButton: Component {

    public let label: String
    public let href: String?
    public let style: NewAdminButtonStyle

    public init(
        _ label: String,
        href: String? = nil,
        style: NewAdminButtonStyle = .primary
    ) {
        self.label = label
        self.href = href
        self.style = style
    }

    public func html(context: inout RenderContext) -> A {
        var link = A(label)
        if let href, style != .disabled {
            link = link.href(href)
        }
        return link.class("button", style.className)
    }
}
