import AuthModule
import CSS
import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

extension MagicLink.App {
    struct Page: Component {
        let email: String
        let isPersistent: Bool
        let error: String?
        let message: String?
        let turnstileSiteKey: String?
        let routes: Router.Routes

        func rules() -> [any Rule] {
            AdminDesignSystem().rules() + [Media(selectors: selectors())]
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
                    Background(
                        .variable(TokenKey.Colors.Materials.Primary.tint)
                    )
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
                Custom(".login-card .admin-form") { MarginTop(24.px) },
                Custom(".login-card .admin-form__actions") {
                    AlignItems(.stretch)
                },
                Custom(".login-card .admin-form__actions .button") {
                    Width(100.percent)
                },
                Custom(".login-card .admin-form__success") {
                    Margin(0)
                    Padding(vertical: 12.px, horizontal: 14.px)
                    BorderRadius(8.px)
                    Border(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Palette.Green.border)
                    )
                    Background(
                        .variable(TokenKey.Colors.Palette.Green.background)
                    )
                    Color(.variable(TokenKey.Colors.Palette.Green.text))
                },
                Class("login-actions") {
                    Display(.flex)
                    FlexDirection(.column)
                    AlignItems(.stretch)
                    Gap(10.px)
                    MarginTop(32.px)
                },
                Custom(".login-actions .button") { Width(100.percent) },
            ]
        }

        func html(context: inout BuilderContext) -> Main {
            Main {
                Div {
                    context.build(
                        AdminPageHeader(
                            state: .primary(
                                title: "Sign in",
                                description:
                                    "Enter your email to receive a sign-in link."
                            )
                        )
                    )
                    context.build(
                        AdminForm(action: routes.request.path) {
                            if let message {
                                P(message).class("admin-form__success")
                            }
                            if let error {
                                P(error).class("admin-form__error")
                            }
                            context.build(
                                AdminFormFieldInput(
                                    state: .init(
                                        name: "email",
                                        label: "Email address",
                                        value: email,
                                        type: .email,
                                        isRequired: true
                                    )
                                )
                            )
                            context.build(
                                AdminFormFieldCheckbox(
                                    state: .init(
                                        name: "is_persistent",
                                        label: "Session",
                                        checkboxLabel: "Permanent link",
                                        isChecked: isPersistent
                                    )
                                )
                            )
                            if let siteKey = turnstileSiteKey,
                                !siteKey.isEmpty
                            {
                                Div {}.class("cf-turnstile")
                                    .data(
                                        "sitekey",
                                        siteKey
                                    )
                                Script()
                                    .src(
                                        "https://challenges.cloudflare.com/turnstile/v0/api.js"
                                    )
                                    .async()
                                    .defer()
                            }
                            Div {
                                context.build(
                                    AdminSubmitButton("Send magic link")
                                )
                            }
                            .class("admin-form__actions")
                        }
                    )
                    Div {
                        context.build(
                            AdminButton(
                                "Sign in with credentials",
                                href: routes.login.path,
                                style: .ghost(.primary)
                            )
                        )
                        context.build(
                            AdminButton(
                                "Home",
                                href: routes.home.path,
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
}
