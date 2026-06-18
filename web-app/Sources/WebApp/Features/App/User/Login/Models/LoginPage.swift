import CSS
import HTML
import SGML
import WebStandards

struct LoginPage: Component, FlowContent {

    struct State {
        var form: LoginForm.State
        var message: String?
    }

    var state: State

    func selectors() -> [any Selector] {
        Class("login-shell") {
            Display(.grid)
            MinHeight(100.vh)
            Padding(vertical: 32.px, horizontal: 20.px)
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
        Class("login-card") {
            UnsafeRawProperty(name: "width", value: "min(100%, 28rem)")
            Display(.grid)
            Gap(18.px)
            Padding(24.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(22.px)
            UnsafeRawProperty(
                name: "background",
                value:
                    "linear-gradient(180deg, var(--cms-white) 0%, var(--cms-gray-1) 100%)"
            )
            UnsafeRawProperty(name: "box-shadow", value: "var(--cms-shadow)")
        }
        Class("login-copy") {
            Display(.grid)
            Gap(6.px)
        }
        Custom(".login-copy .login-kicker") {
            UnsafeRawProperty(name: "color", value: "var(--cms-accent-color)")
            FontSize(0.72.rem)
            FontWeight(700)
            LetterSpacing(0.14.em)
            TextTransform(.uppercase)
        }
        Custom(".login-copy h1") {
            Margin(0)
            UnsafeRawProperty(
                name: "font-size",
                value: "clamp(2rem, 5vw, 2.5rem)"
            )
            LineHeight(1.05)
            LetterSpacing((-0.04).em)
            Color(.variable("cms-strong-font"))
        }
        Custom(".login-copy p") {
            Margin(0)
            Color(.variable("cms-light-font"))
            FontSize(0.96.rem)
            LineHeight(1.55)
        }
        Class("login-form") {
            Display(.grid)
            Gap(14.px)
        }
        Class("login-field") {
            Display(.grid)
            Gap(8.px)
        }
        Class("login-checkbox-field") {
            Display(.flex)
            AlignItems(.center)
            Gap(10.px)
        }
        Custom(".login-checkbox-field span") {
            Color(.variable("cms-strong-font"))
            FontSize(0.95.rem)
            LineHeight(1.3)
        }
        Custom(".login-checkbox-field input[type=\"checkbox\"]") {
            FlexShrink(0)
        }
        Custom(".login-form input[type=\"submit\"]") {
            Width(100.percent)
            Display(.inlineFlex)
            AlignItems(.center)
            JustifyContent(.center)
            Padding(vertical: 12.px, horizontal: 18.px)
            BorderRadius(999.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            Background(color: .color(.variable("cms-strong-font")))
            Color(.variable("cms-white"))
            FontWeight(600)
            LineHeight(1)
        }
        Class("login-home-link") {
            UnsafeRawProperty(name: "justify-self", value: "center")
            Color(.variable("cms-light-font"))
            FontSize(0.92.rem)
        }
        Custom(".login-home-link:hover") {
            Color(.variable("cms-strong-font"))
        }
        Class("login-error") {
            Margin(0)
            Padding(vertical: 10.px, horizontal: 12.px)
            Border(1.px, .solid, .variable("cms-red-border"))
            BorderRadius(10.px)
            Background(color: .color(.variable("cms-red")))
            Color(.variable("cms-strong-font"))
            FontSize(0.92.rem)
            LineHeight(1.45)
        }
    }

    func content() -> some BasicTag {
        Main {
            Div {
                Div {
                    Span("Feather CMS").class("login-kicker")
                    H1("Sign in")
                    P("Use your admin account to continue.")
                }
                .class("login-copy")

                LoginForm(state: state.form)

                if let message = state.message {
                    P(message).class("login-error")
                }

                A("Home").href("/").class("login-home-link")
            }
            .class("login-card")
        }
        .class("login-shell")
        .setAttribute(name: "role", value: "main")
    }
}
