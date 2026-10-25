public import CSS
import Foundation
public import HTML
import SGML
import SVG
import WebBuilders
public import WebComponents

public struct AdminCopyButton: Component {
    public let value: String
    public let label: String
    public let copiedMessage: String

    public init(
        value: String,
        label: String,
        copiedMessage: String
    ) {
        self.value = value
        self.label = label
        self.copiedMessage = copiedMessage
    }

    public func selectors() -> [any CSS.Selector] {
        AdminNotification.styleSelectors() + [
            Class("admin-copy-button") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Width(1.25.rem)
                Height(1.25.rem)
                Padding(0)
                Border(0)
                BackgroundColor(.transparent)
                Color(.variable(TokenKey.Colors.Link.default))
                FlexShrink(0)
                Cursor(.pointer)
                VerticalAlign(.middle)
            }
        ]
    }

    public func html(context: inout BuilderContext) -> Button {
        let notificationScript = AdminNotification.showScript(
            .init(title: "Copied", message: copiedMessage)
        )

        var button = Button {
            FeatherIcons.clipboard()
                .width(16)
                .height(16)
        }
        .type(.button)
        .ariaLabel(label)
        .class("admin-copy-button")
        button = button.onClick(
            "navigator.clipboard.writeText(\(javascriptString(value))).then(()=>\(notificationScript))"
        )
        return button
    }

    private func javascriptString(_ value: String) -> String {
        let escaped =
            value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
        return "'\(escaped)'"
    }
}
