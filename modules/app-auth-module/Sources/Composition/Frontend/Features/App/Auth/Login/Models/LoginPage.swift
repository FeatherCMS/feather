import CSS
import FeatherAdmin
import HTML
import WebBuilders
import WebComponents

struct LoginPage: Component {

    struct State {
        var form: LoginForm.State
        var message: String?
    }

    var state: State

    func rules() -> [any Rule] {
        NewAdminDesignSystem().rules()
            + [Media(selectors: selectors())]
    }

    func selectors() -> [any Selector] {
        [
            Custom("body") {
                Background(
                    .variable(TokenKey.Colors.Materials.Secondary.tint)
                )
            },
            Class("login-page") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.center)
                BoxSizing(.borderBox)
                Padding(vertical: 32.px, horizontal: 20.px)
                Background(
                    .variable(TokenKey.Colors.Materials.Secondary.tint)
                )
            },
            Class("login-card") {
                Width(100.percent)
                MaxWidth(440.px)
                BoxSizing(.borderBox)
                MarginTop(10.percent)
                Padding(32.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                BorderRadius(20.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                BoxShadow(
                    0.px,
                    12.px,
                    blur: 26.px,
                    spread: 2.px,
                    color: CSSColor(
                        stringLiteral:
                            "var(--\(TokenKey.Colors.BoxShadow.tint.propertyName))"
                    )
                )
            },
            Custom(".login-card .admin-page-header") {
                Margin(bottom: 0.px)
            },
            Custom(".login-card .new-admin-form") {
                MarginTop(24.px)
            },
            Custom(".login-card .new-admin-form__actions") {
                AlignItems(.stretch)
            },
            Custom(".login-card .new-admin-form__actions .button") {
                Width(100.percent)
            },
            Class("login-actions") {
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.stretch)
                Gap(10.px)
                MarginTop(32.px)
            },
            Custom(".login-actions .button") {
                Width(100.percent)
            },
        ]
    }

    func html(context: inout BuilderContext) -> Main {
        Main {
            Div {
                context.build(
                    NewAdminPageHeader(
                        state: .init(
                            title: "Sign in",
                            description: "Use your user account to continue."
                        )
                    )
                )

                context.build(
                    LoginForm(
                        state: state.form,
                        message: state.message
                    )
                )

                Div {
                    context.build(
                        NewAdminButton(
                            "Sign in with a magic link",
                            href: "/magic-link/",
                            style: .ghost(.primary)
                        )
                    )
                    context.build(
                        NewAdminButton(
                            "Home",
                            href: "/",
                            style: .ghost(.secondary)
                        )
                    )
                }
                .class("login-actions")
            }
            .class("login-card")
        }
        .class("login-page")
        .role("main")
    }
}
