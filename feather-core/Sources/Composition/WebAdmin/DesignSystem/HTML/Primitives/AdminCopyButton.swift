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
        [
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
        Button {
            FeatherIcons.externalLink()
                .width(16)
                .height(16)
        }
        .type(.button)
        .ariaLabel(label)
        .onClick(
            "navigator.clipboard.writeText(\(javascriptString(value))).then(()=>window.toast&&window.toast.success('Copied',\(javascriptString(copiedMessage))))"
        )
        .class("admin-copy-button")
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
