public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminSubmitButton: Component {

    public let label: String
    public let style: AdminButtonStyle
    public let isRowButton: Bool

    public init(
        _ label: String = "Submit",
        style: AdminButtonStyle = .primary,
        isRowButton: Bool = false
    ) {
        self.label = label
        self.style = style
        self.isRowButton = isRowButton
    }

    public init(state: AdminButton.State, isRowButton: Bool = false) {
        self.init(
            state.label,
            style: state.style,
            isRowButton: isRowButton
        )
    }

    public func html(context: inout BuilderContext) -> Button {
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
