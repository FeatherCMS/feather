public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminButton: Component {

    public struct State: Sendable, Equatable {
        public let label: String
        public let href: String?
        public let style: NewAdminButtonStyle

        public init(
            label: String,
            href: String? = nil,
            style: NewAdminButtonStyle = .primary
        ) {
            self.label = label
            self.href = href
            self.style = style
        }
    }

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

    public init(state: State) {
        self.init(state.label, href: state.href, style: state.style)
    }

    public func html(context: inout BuilderContext) -> A {
        var link = A(label)
        if let href, style != .disabled {
            link = link.href(href)
        }
        return link.class("button", style.className)
    }
}
