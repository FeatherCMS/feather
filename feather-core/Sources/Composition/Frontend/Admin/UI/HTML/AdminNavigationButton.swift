import HTML
import SGML
import WebStandards

public struct AdminNavigationButton: Component, FlowContent {
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

    public func content() -> some BasicTag {
        var button = Button(label)
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
