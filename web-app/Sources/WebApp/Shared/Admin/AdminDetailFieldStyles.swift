import CSS
import WebStandards

enum AdminDetailFieldStyles {

    static func selectors() -> [any Selector] {
        [
            Class("admin-details-field") {
                MarginBottom(16.px)
            },
            Class("admin-details-field__label") {
                Margin(top: 0.px, right: 0.px, bottom: 6.px, left: 0.px)
                Color(.variable("cms-strong-font"))
                FontWeight(.number(600))
            },
            Class("admin-details-field__value") {
                Margin(0.px)
                Color(.variable("cms-strong-font"))
            },
            Class("admin-detail-actions") {
                MarginTop(24.px)
            },
        ]
    }
}
