public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminRowButton: Component {

    public let label: String
    public let href: String?
    public let style: AdminButtonStyle
    public let dialogURL: String?

    public init(
        _ label: String,
        href: String? = nil,
        style: AdminButtonStyle = .primary,
        dialogURL: String? = nil
    ) {
        self.label = label
        self.href = href
        self.style = style
        self.dialogURL = dialogURL
    }

    public func html(context: inout BuilderContext) -> A {
        var link = A(label)
        if let href, style != .disabled {
            link = link.href(href)
        }
        if let dialogURL = dialogURL
            ?? (style == .destructive ? href : nil)
        {
            link = link.data("admin-dialog-url", dialogURL)
            if style == .destructive {
                link = link.data("admin-remove-confirm", "true")
            }
        }
        return link.class("button", style.className, "row-button")
    }
}
