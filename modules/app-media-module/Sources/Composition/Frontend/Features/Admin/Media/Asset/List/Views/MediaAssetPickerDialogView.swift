import CSS
import FeatherAdmin
import FeatherValidation
import HTML
import SGML
import WebBuilders
import WebComponents

struct MediaAssetPickerDialogNavigation: Sendable {
    let field: String?
    let selectionMode: MediaAssetSelectionMode

    init(
        field: String?,
        selectionMode: MediaAssetSelectionMode = .single
    ) {
        self.field = field
        self.selectionMode = selectionMode
    }
}

struct MediaAssetPickerDialogView<Content: Component>: Component {
    let navigation: MediaAssetPickerDialogNavigation
    let content: Content

    func rules() -> [any CSS.Rule] {
        content.rules() + [
            Media {
                Class("media-asset-picker-dialog") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(16.px)
                    Height(70.vh)
                    Overflow(.hidden)
                    BoxSizing(.borderBox)
                    Padding(vertical: 2.px, horizontal: 3.px)
                }
                Custom(".media-asset-picker-dialog > .media-asset-picker") {
                    Height(100.percent)
                    MinHeight(0.px)
                }
                Custom(".media-asset-picker-dialog .media-asset-picker__body") {
                    OverflowY(.auto)
                    OverflowX(.hidden)
                }
            }
        ]
    }

    func html(context: inout BuilderContext) -> Div {
        Div {
            context.build(content)
        }
        .class("media-asset-picker-dialog")
        .data("media-picker-field", navigation.field ?? "")
        .data("media-picker-selection", navigation.selectionMode.rawValue)
    }
}
