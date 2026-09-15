import HTML
import SGML
import WebBuilders
import WebComponents

public typealias AdminNavigationRenderedButton = HTML.Button

@available(
    *,
    deprecated,
    message: "Use NewAdminButton or a navigation link instead."
)
public struct AdminNavigationButton: Component {
    public let label: String
    public let href: String
    public let className: String?

    public init(
        _ label: String,
        href: String,
        classes: [String] = []
    ) {
        self.label = label
        self.href = href
        self.className = classes.isEmpty ? nil : classes.joined(separator: " ")
    }

    public func html(context: inout BuilderContext)
        -> AdminNavigationRenderedButton
    {
        var button = AdminNavigationRenderedButton(label)
            .type(.button)
            .onClick(
                "window.location.href='\(href)'"
            )
        if let className {
            button = button.class(className)
        }
        return button
    }

}
