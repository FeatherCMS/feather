import CSS
import HTML
import SGML
import WebStandards

struct AppPublicStyleAnchor: Component, FlowContent {
    func selectors() -> [any Selector] {
        Class("public-shell") {
            MinHeight(100.vh)
            Padding(vertical: 40.px, horizontal: 20.px)
            UnsafeRawProperty(
                name: "background",
                value: """
                    radial-gradient(circle at top, rgba(156, 136, 255, 0.12) 0%, transparent 32%),
                    linear-gradient(180deg, var(--cms-gray-1) 0%, var(--cms-white) 100%)
                    """
            )
        }
        Class("public-container") {
            UnsafeRawProperty(name: "width", value: "min(100%, 72rem)")
            UnsafeRawProperty(name: "margin-inline", value: "auto")
            Display(.grid)
            Gap(24.px)
        }
        Class("public-panel") {
            Display(.grid)
            Gap(20.px)
            Padding(28.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(24.px)
            Background(color: .color(.variable("cms-white")))
            UnsafeRawProperty(name: "box-shadow", value: "var(--cms-shadow)")
        }
        Class("public-heading") {
            Display(.grid)
            Gap(10.px)
        }
        Custom(".public-heading h1") {
            Margin(0)
            Color(.variable("cms-strong-font"))
            UnsafeRawProperty(
                name: "font-size",
                value: "clamp(2.2rem, 6vw, 3.6rem)"
            )
            LineHeight(1.02)
            LetterSpacing((-0.05).em)
        }
        Custom(".public-heading p") {
            Margin(0)
            Color(.variable("cms-light-font"))
            FontSize(1.rem)
            LineHeight(1.65)
        }
        Class("public-eyebrow") {
            Margin(0)
            UnsafeRawProperty(name: "color", value: "var(--cms-accent-color)")
            FontSize(0.8.rem)
            FontWeight(700)
            LetterSpacing(0.12.em)
            TextTransform(.uppercase)
        }
        Class("public-meta") {
            Display(.flex)
            FlexWrap(.wrap)
            Gap(10.px)
        }
        Custom(".public-meta span") {
            Display(.inlineFlex)
            AlignItems(.center)
            Padding(vertical: 8.px, horizontal: 12.px)
            BorderRadius(999.px)
            Background(color: .color(.variable("cms-gray-2")))
            Color(.variable("cms-light-font"))
            FontSize(0.84.rem)
            FontWeight(600)
        }
        Class("public-image") {
            BorderRadius(20.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            Overflow(.hidden)
            Background(color: .color(.variable("cms-gray-2")))
        }
        Custom(".public-image img") {
            Display(.block)
            Width(100.percent)
            Height(.auto)
        }
        Class("public-body") {
            Color(.variable("cms-strong-font"))
            LineHeight(1.75)
            UnsafeRawProperty(name: "white-space", value: "pre-wrap")
        }
        Custom(".public-body p, .public-body div") {
            Margin(0)
        }
        Class("public-grid") {
            Display(.grid)
            Gap(16.px)
            UnsafeRawProperty(
                name: "grid-template-columns",
                value: "repeat(auto-fit, minmax(16rem, 1fr))"
            )
        }
        Class("public-card") {
            Display(.grid)
            Gap(12.px)
            Padding(18.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(18.px)
            Background(color: .color(.variable("cms-gray-1")))
            TextDecoration(.none)
        }
        Custom(".public-card h2, .public-card h3") {
            Margin(0)
            Color(.variable("cms-strong-font"))
            FontSize(1.1.rem)
        }
        Custom(".public-card p") {
            Margin(0)
            Color(.variable("cms-light-font"))
            LineHeight(1.6)
        }
        Custom(".public-card:hover") {
            Transform(.translateY((-1).px))
            BorderColor(.variable("cms-gray-4"))
        }
        Class("public-section") {
            Display(.grid)
            Gap(16.px)
        }
        Custom(".public-section h2") {
            Margin(0)
            Color(.variable("cms-strong-font"))
            FontSize(1.45.rem)
        }
        Class("public-links") {
            Display(.flex)
            FlexWrap(.wrap)
            Gap(10.px)
        }
        Custom(".public-links a") {
            Display(.inlineFlex)
            AlignItems(.center)
            Padding(vertical: 8.px, horizontal: 12.px)
            BorderRadius(999.px)
            Background(color: .color(.variable("cms-gray-2")))
            Color(.variable("cms-strong-font"))
            TextDecoration(.none)
            FontWeight(600)
        }
    }

    func content() -> some BasicTag {
        Div {}
    }
}
