import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminControlButton: Leaf {

    public let label: String
    public let style: NewAdminButtonStyle

    public init(
        _ label: String,
        style: NewAdminButtonStyle = .primary
    ) {
        self.label = label
        self.style = style
    }


    public func html(
    ) -> Button {
        var button = Button(label)
            .type(.button)
            .class("button", style.className)
        if style == .disabled {
            button = button.disabled()
        }
        return button
    }
}
