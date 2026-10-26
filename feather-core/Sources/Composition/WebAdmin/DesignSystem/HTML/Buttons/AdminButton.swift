public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminButton: Component {

    public struct State: Sendable, Equatable {
        public let label: String
        public let href: String?
        public let style: AdminButtonStyle

        public init(
            label: String,
            href: String? = nil,
            style: AdminButtonStyle = .primary
        ) {
            self.label = label
            self.href = href
            self.style = style
        }
    }

    public let label: String
    public let href: String?
    public let style: AdminButtonStyle

    public init(
        _ label: String,
        href: String? = nil,
        style: AdminButtonStyle = .primary
    ) {
        self.label = label
        self.href = href
        self.style = style
    }

    public init(state: State) {
        self.init(state.label, href: state.href, style: state.style)
    }

    public func html(context: inout BuilderContext) -> A {
        var link = A(label)
        if let href, style != .disabled {
            link = link.href(href)
        }
        if style == .destructive, let href {
            link = link
                .data("admin-dialog-url", href)
                .data("admin-remove-confirm", "true")
        }
        return link.class("button", style.className)
    }
}
