import CSS
import FeatherAdmin
import FeatherValidation
import HTML
import SGML
import WebBuilders
import WebComponents

struct MediaAssetPickerDialogNavigation: Sendable {
    let field: String?

    init(field: String?) {
        self.field = field
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
    }
}
