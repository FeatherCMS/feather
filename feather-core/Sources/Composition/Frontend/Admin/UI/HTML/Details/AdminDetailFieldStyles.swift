import CSS
import WebBuilders
import WebComponents

public enum AdminDetailFieldStyles {

    static func selectors() -> [any Selector] {
        [
            Class("admin-details-field") {
                MarginBottom(16.px)
            },
            Class("admin-details-field__label") {
                Margin(top: 0.px, right: 0.px, bottom: 6.px, left: 0.px)
                //                Color(.variable(TokenKey.Background.primary))
                FontWeight(.number(600))
            },
            Class("admin-details-field__value") {
                Margin(0.px)
                //                Color(.variable(TokenKey.Background.primary))
            },
            Class("admin-detail-actions") {
                MarginTop(24.px)
            },
        ]
    }
}
