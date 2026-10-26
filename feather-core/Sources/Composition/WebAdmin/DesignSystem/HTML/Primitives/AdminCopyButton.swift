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
            FeatherIcons.clipboard()
                .width(16)
                .height(16)
        }
        .type(.button)
        .ariaLabel(label)
        .class("admin-copy-button")
        .data("copy-value", value)
        .data("copy-message", copiedMessage)
    }

    public func scripts() -> [String] {
        [
            #"""
            document.addEventListener("click", function (event) {
                var target = event.target;
                var button = target && target.closest
                    ? target.closest(".admin-copy-button")
                    : null;
                if (!button) {
                    return;
                }

                function show(kind, title, message) {
                    if (window.adminNotification) {
                        window.adminNotification.show({
                            kind: kind,
                            title: title,
                            message: message
                        });
                    }
                }

                try {
                    if (!navigator.clipboard || !navigator.clipboard.writeText) {
                        throw new Error("Clipboard API unavailable");
                    }
                    navigator.clipboard.writeText(button.dataset.copyValue || "")
                        .then(function () {
                            show("success", "Copied", button.dataset.copyMessage || "Copied to clipboard");
                        })
                        .catch(function () {
                            show("error", "Copy failed", "Could not copy to the clipboard.");
                        });
                } catch (_) {
                    show("error", "Copy failed", "Could not copy to the clipboard.");
                }
            });
            """#
        ]
    }
}
