import CSS
import WebStandards

extension FeatherCSS {

    public enum Buttons {

        public static func selectors() -> [any Selector] {
            return [
                Custom(".feather-button") {
                    Display(.inlineFlex)
                    AlignItems(.center)
                    JustifyContent(.center)
                    MinHeight(40.px)
                    BoxSizing(.borderBox)
                    Padding(vertical: 10.px, horizontal: 16.px)
                    Border(1.px, .solid, .variable("cms-gray-3"))
                    BorderRadius(8.px)
                    FontSize(0.95.rem)
                    FontWeight(600)
                    LineHeight(1.2)
                    TextDecoration(.none)
                    Cursor(.pointer)
                },

                Custom(".feather-button:hover") {
                    TextDecoration(.none)
                },

                Custom(".feather-button:focus-visible") {
                    UnsafeRawProperty(
                        name: "outline",
                        value: "2px solid var(--cms-primary-border)"
                    )
                    UnsafeRawProperty(name: "outline-offset", value: "2px")
                },

                Custom(".feather-button--primary") {
                    Background(color: .variable("cms-primary"))
                    BorderColor(.variable("cms-primary-border"))
                    Color(.variable("cms-white"))
                },

                Custom(".feather-button--primary:hover") {
                    Background(color: .variable("cms-primary-hover"))
                    BorderColor(.variable("cms-primary-hover"))
                    Color(.variable("cms-white"))
                },

                Custom(".feather-button--secondary") {
                    Background(color: .variable("cms-white"))
                    BorderColor(.variable("cms-gray-3"))
                    Color(.variable("cms-strong-font"))
                },

                Custom(".feather-button--secondary:hover") {
                    Background(color: .variable("cms-gray-1"))
                    BorderColor(.variable("cms-gray-4"))
                    Color(.variable("cms-strong-font"))
                },

                Custom(".feather-button--destructive") {
                    Background(color: .variable("cms-destructive"))
                    BorderColor(.variable("cms-destructive-border"))
                    Color(.variable("cms-white"))
                },

                Custom(".feather-button--destructive:hover") {
                    Background(color: .variable("cms-destructive-border"))
                    BorderColor(.variable("cms-destructive-border"))
                    Color(.variable("cms-white"))
                },

                Custom(".feather-button--action") {
                    MinHeight(32.px)
                    Padding(vertical: 7.px, horizontal: 10.px)
                    BorderRadius(6.px)
                    FontSize(0.875.rem)
                },
            ]
        }

    }
}
