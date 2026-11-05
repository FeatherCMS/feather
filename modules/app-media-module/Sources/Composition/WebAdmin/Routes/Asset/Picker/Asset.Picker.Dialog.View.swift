import CSS
import FeatherValidation
import FeatherWebAdmin
import HTML
import MediaModule
import SGML
import WebBuilders
import WebComponents

extension Asset.Picker.Dialog {
    struct View<Content: Component>: Component {
        let navigation: Navigation
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
                    Custom(
                        ".media-asset-picker-dialog .media-asset-picker__body"
                    ) {
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
}
