public import FeatherWebAdmin
public import HTML
import WebBuilders
public import WebComponents

public struct AdminMediaAssetPickerButton: Component {
    public let label: String
    public let style: AdminButtonStyle
    public let configuration: MediaAssetPopupConfiguration

    public init(
        _ label: String = "Choose asset",
        style: AdminButtonStyle = .ghost(.primary),
        configuration: MediaAssetPopupConfiguration
    ) {
        self.label = label
        self.style = style
        self.configuration = configuration
    }

    public func html(context: inout BuilderContext) -> Button {
        var button = context.build(
            AdminControlButton(label, style: style)
        )
        button =
            button
            .data(
                "admin-dialog-url",
                configuration.url(for: .choose)
            )
            .data("media-picker-open", configuration.field)
            .data(
                "media-picker-selection",
                configuration.selectionMode.rawValue
            )
        return button
    }
}
