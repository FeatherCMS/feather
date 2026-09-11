import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminSubmitButton: Leaf {

    public let label: String
    public let style: NewAdminButtonStyle

    public init(
        _ label: String = "Submit",
        style: NewAdminButtonStyle = .primary
    ) {
        self.label = label
        self.style = style
    }

    public func html(
    ) -> Button {
        var button = Button(label)
            .type(.submit)
            .class("button", style.className)
        if style == .disabled {
            button = button.disabled()
        }
        return button
    }
}
