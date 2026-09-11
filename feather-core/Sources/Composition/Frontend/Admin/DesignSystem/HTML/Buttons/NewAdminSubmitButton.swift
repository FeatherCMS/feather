import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminSubmitButton: Component {

    public let label: String
    public let style: NewAdminButtonStyle
    public let isRowButton: Bool

    public init(
        _ label: String = "Submit",
        style: NewAdminButtonStyle = .primary,
        isRowButton: Bool = false
    ) {
        self.label = label
        self.style = style
        self.isRowButton = isRowButton
    }

    public func html(context: inout RenderContext) -> Button {
        var button = Button(label)
            .type(.submit)
            .class("button", style.className)
        if isRowButton {
            button = button.class("row-button")
        }
        if style == .disabled {
            button = button.disabled()
        }
        return button
    }
}
