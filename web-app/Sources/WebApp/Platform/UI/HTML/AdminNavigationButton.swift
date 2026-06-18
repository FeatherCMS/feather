import HTML
import SGML
import WebStandards

struct AdminNavigationButton: Component, FlowContent {
    let label: String
    let href: String
    let className: String?

    init(
        _ label: String,
        href: String,
        classes: [String] = []
    ) {
        self.label = label
        self.href = href
        self.className = classes.isEmpty ? nil : classes.joined(separator: " ")
    }

    func content() -> some BasicTag {
        var button = Button(label)
            .type(.button)
            .setAttribute(
                name: "onclick",
                value: "window.location.href='\(href)'"
            )
        if let className {
            button = button.class(className)
        }
        return button
    }
}
