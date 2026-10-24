public import FeatherWebAdmin
public import HTML
public import MediaModule
import WebBuilders
public import WebComponents

extension Asset.Picker {
    public struct UploadButton: Component {
        public let label: String
        public let style: AdminButtonStyle
        public let configuration: Asset.Picker.Popup.Configuration

        public init(
            _ label: String = "Upload asset",
            style: AdminButtonStyle = .ghost(.primary),
            configuration: Asset.Picker.Popup.Configuration
        ) {
            self.label = label
            self.style = style
            self.configuration = configuration
        }

        public func html(context: inout BuilderContext) -> HTML.Button {
            var button = context.build(
                AdminControlButton(label, style: style)
            )
            button =
                button
                .data(
                    "admin-dialog-url",
                    configuration.url(for: .upload)
                )
                .data("media-picker-open", configuration.field)
                .data(
                    "media-picker-selection",
                    configuration.selectionMode.rawValue
                )
            return button
        }
    }
}
