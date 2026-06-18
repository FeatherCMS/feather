import CSS
import HTML
import SGML
import WebStandards

struct AppNotFoundPage: Component, FlowContent {

    func selectors() -> [any Selector] {
        Class("home-shell") {
            Display(.grid)
            MinHeight(100.vh)
            Padding(24.px)
            UnsafeRawProperty(name: "place-items", value: "center")
            UnsafeRawProperty(
                name: "background",
                value: """
                    radial-gradient(circle at top, rgba(156, 136, 255, 0.16) 0%, transparent 34%),
                    radial-gradient(circle at bottom right, rgba(28, 27, 31, 0.08) 0%, transparent 30%),
                    linear-gradient(180deg, var(--cms-gray-1) 0%, var(--cms-white) 100%)
                    """
            )
        }
        Class("home-panel") {
            UnsafeRawProperty(name: "width", value: "min(100%, 34rem)")
            Display(.grid)
            Gap(20.px)
            Padding(28.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(20.px)
            Background(color: .color(.variable("cms-white")))
            UnsafeRawProperty(name: "box-shadow", value: "var(--cms-shadow)")
        }
        Class("home-heading") {
            Display(.grid)
            Gap(6.px)
        }
        Custom(".home-heading .home-kicker") {
            Margin(0)
            UnsafeRawProperty(name: "color", value: "var(--cms-accent-color)")
            FontSize(0.75.rem)
            FontWeight(700)
            LetterSpacing(0.16.em)
            TextTransform(.uppercase)
        }
        Custom(".home-heading h1") {
            Margin(0)
            Color(.variable("cms-strong-font"))
            UnsafeRawProperty(
                name: "font-size",
                value: "clamp(1.8rem, 4vw, 2.3rem)"
            )
            LineHeight(1.05)
            LetterSpacing((-0.04).em)
        }
        Class("home-copy") {
            Display(.grid)
            Gap(8.px)
        }
        Custom(".home-copy p") {
            Margin(0)
            Color(.variable("cms-light-font"))
            FontSize(0.96.rem)
            LineHeight(1.5)
        }
        Class("home-actions") {
            Display(.flex)
            FlexWrap(.wrap)
            Gap(12.px)
        }
        Class("home-button") {
            Display(.inlineFlex)
            AlignItems(.center)
            JustifyContent(.center)
            MinWidth(8.rem)
            Padding(vertical: 10.px, horizontal: 16.px)
            BorderRadius(999.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            TextDecoration(.none)
            FontWeight(600)
            LineHeight(1)
        }
        Class("home-primary") {
            Background(color: .color(.variable("cms-strong-font")))
            BorderColor(.variable("cms-strong-font"))
            Color(.variable("cms-white"))
        }
        Custom(".home-button:hover") {
            Transform(.translateY((-1).px))
            BoxShadow(
                0,
                8.px,
                blur: 18.px,
                color: .init(r: 0, g: 0, b: 0, a: 0.08)
            )
        }
    }

    func content() -> some BasicTag {
        Main {
            Div {
                Div {
                    P("Feather CMS").class("home-kicker")
                    H1("Page not found")
                }
                .class("home-heading")

                Div {
                    P(
                        "The page you requested does not exist or is not available."
                    )
                    P("Use the button below to go back to the home page.")
                }
                .class("home-copy")

                Div {
                    A("Go home")
                        .href("/")
                        .class("home-button", "home-primary")
                }
                .class("home-actions")
            }
            .class("home-panel")
        }
        .class("home-shell")
        .setAttribute(name: "role", value: "main")
    }
}
