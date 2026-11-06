import AccountModule
import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

extension Invitation.Accept.View {
    struct Page: Component {
        let action: String
        let loginPath: String
        let token: String
        let email: String?
        let password: String
        let confirmation: String
        let error: String?
        let success: String?

        func rules() -> [any Rule] {
            [
                Media(selectors: selectors()),
                Media(.prefersColorScheme(.dark)) {
                    Custom(":root") {
                        UnsafeRawProperty(
                            name: "--auth-primary-tint",
                            value: "#19191b"
                        )
                        UnsafeRawProperty(
                            name: "--auth-primary-text",
                            value: "#f7fbff"
                        )
                        UnsafeRawProperty(
                            name: "--auth-primary-border",
                            value: "#2b2b2e"
                        )
                        UnsafeRawProperty(
                            name: "--auth-secondary-tint",
                            value: "#202023"
                        )
                        UnsafeRawProperty(
                            name: "--auth-secondary-text",
                            value: "#e9edf2"
                        )
                        UnsafeRawProperty(
                            name: "--auth-tertiary-tint",
                            value: "#28282b"
                        )
                        UnsafeRawProperty(
                            name: "--auth-tertiary-text",
                            value: "#e0dde5"
                        )
                        UnsafeRawProperty(
                            name: "--auth-tertiary-border",
                            value: "#38383e"
                        )
                        UnsafeRawProperty(
                            name: "--auth-primary-accent",
                            value: "#7a43d1"
                        )
                        UnsafeRawProperty(
                            name: "--auth-primary-accent-border",
                            value: "#733fc2"
                        )
                        UnsafeRawProperty(
                            name: "--auth-primary-accent-hover",
                            value: "#8c4ef0"
                        )
                        UnsafeRawProperty(
                            name: "--auth-link-hover",
                            value: "#c38cff"
                        )
                        UnsafeRawProperty(
                            name: "--auth-primary-ghost",
                            value: "#3a3a3e"
                        )
                        UnsafeRawProperty(
                            name: "--auth-primary-ghost-text",
                            value: "#f5f0f7"
                        )
                        UnsafeRawProperty(
                            name: "--auth-primary-ghost-border",
                            value: "#525255"
                        )
                        UnsafeRawProperty(
                            name: "--auth-primary-ghost-hover",
                            value: "#525255"
                        )
                        UnsafeRawProperty(
                            name: "--auth-secondary-ghost",
                            value: "#242428"
                        )
                        UnsafeRawProperty(
                            name: "--auth-secondary-ghost-text",
                            value: "#d6d1dc"
                        )
                        UnsafeRawProperty(
                            name: "--auth-secondary-ghost-border",
                            value: "#3b3b42"
                        )
                        UnsafeRawProperty(
                            name: "--auth-secondary-ghost-hover",
                            value: "#3b3b42"
                        )
                        UnsafeRawProperty(
                            name: "--auth-error-background",
                            value: "rgba(255, 69, 58, 0.16)"
                        )
                        UnsafeRawProperty(
                            name: "--auth-error-border",
                            value: "rgba(255, 105, 97, 0.58)"
                        )
                        UnsafeRawProperty(
                            name: "--auth-error-text",
                            value: "#fff"
                        )
                        UnsafeRawProperty(
                            name: "--auth-success-background",
                            value: "rgba(48, 209, 88, 0.16)"
                        )
                        UnsafeRawProperty(
                            name: "--auth-success-border",
                            value: "rgba(48, 209, 88, 0.55)"
                        )
                        UnsafeRawProperty(
                            name: "--auth-success-text",
                            value: "#fff"
                        )
                        UnsafeRawProperty(
                            name: "--auth-shadow",
                            value: "rgba(0, 0, 0, 0.24)"
                        )
                    }
                },
            ]
        }

        func selectors() -> [any Selector] {
            [
                Custom(":root") {
                    UnsafeRawProperty(name: "color-scheme", value: "light dark")
                    UnsafeRawProperty(
                        name: "font-family",
                        value: "-apple-system, BlinkMacSystemFont, \"Segoe UI\", sans-serif"
                    )
                    UnsafeRawProperty(name: "--auth-primary-tint", value: "#fff")
                    UnsafeRawProperty(name: "--auth-primary-text", value: "#000")
                    UnsafeRawProperty(name: "--auth-primary-border", value: "#d8dee7")
                    UnsafeRawProperty(name: "--auth-secondary-tint", value: "#f8fafc")
                    UnsafeRawProperty(name: "--auth-secondary-text", value: "#111827")
                    UnsafeRawProperty(name: "--auth-tertiary-tint", value: "#eef0f3")
                    UnsafeRawProperty(name: "--auth-tertiary-text", value: "#374151")
                    UnsafeRawProperty(name: "--auth-tertiary-border", value: "#d9dce1")
                    UnsafeRawProperty(name: "--auth-primary-accent", value: "#6536ab")
                    UnsafeRawProperty(name: "--auth-primary-accent-border", value: "#4b2780")
                    UnsafeRawProperty(name: "--auth-primary-accent-hover", value: "#4b2780")
                    UnsafeRawProperty(name: "--auth-link-hover", value: "#664ca6")
                    UnsafeRawProperty(name: "--auth-primary-ghost", value: "#374151")
                    UnsafeRawProperty(name: "--auth-primary-ghost-text", value: "#fff")
                    UnsafeRawProperty(name: "--auth-primary-ghost-border", value: "#1f2937")
                    UnsafeRawProperty(name: "--auth-primary-ghost-hover", value: "#0f172a")
                    UnsafeRawProperty(name: "--auth-secondary-ghost", value: "#e2e8f0")
                    UnsafeRawProperty(name: "--auth-secondary-ghost-text", value: "#4b5563")
                    UnsafeRawProperty(name: "--auth-secondary-ghost-border", value: "#cbd5e1")
                    UnsafeRawProperty(name: "--auth-secondary-ghost-hover", value: "#cbd5e1")
                    UnsafeRawProperty(name: "--auth-error-background", value: "#fff7f7")
                    UnsafeRawProperty(name: "--auth-error-border", value: "#d14343")
                    UnsafeRawProperty(name: "--auth-error-text", value: "#000")
                    UnsafeRawProperty(name: "--auth-success-background", value: "#ecfdf3")
                    UnsafeRawProperty(name: "--auth-success-border", value: "#a7f3d0")
                    UnsafeRawProperty(name: "--auth-success-text", value: "#000")
                    UnsafeRawProperty(name: "--auth-shadow", value: "rgba(17, 24, 39, 0.08)")
                },
                Custom("*") {
                    BoxSizing(.borderBox)
                },
                Custom("body") {
                    Margin(0.px)
                    MinHeight(100.vh)
                    UnsafeRawProperty(name: "color", value: "var(--auth-secondary-text)")
                    UnsafeRawProperty(
                        name: "background",
                        value: "var(--auth-secondary-tint)"
                    )
                },
                Custom(".login-page") {
                    Display(.flex)
                    AlignItems(.center)
                    JustifyContent(.center)
                    MinHeight(100.vh)
                    Padding(vertical: 32.px, horizontal: 20.px)
                    UnsafeRawProperty(
                        name: "background",
                        value: "var(--auth-secondary-tint)"
                    )
                },
                Custom(".login-card") {
                    Width(100.percent)
                    MaxWidth(440.px)
                    Padding(32.px)
                    BorderRadius(20.px)
                    UnsafeRawProperty(
                        name: "border",
                        value: "1px solid var(--auth-primary-border)"
                    )
                    UnsafeRawProperty(
                        name: "background",
                        value: "var(--auth-primary-tint)"
                    )
                    UnsafeRawProperty(
                        name: "box-shadow",
                        value: "0 12px 26px 2px var(--auth-shadow)"
                    )
                },
                Custom(".login-card .admin-page-header") {
                    MarginBottom(0.px)
                },
                Custom(".admin-page-header h1") {
                    Margin(top: 0.px, bottom: 8.px)
                    UnsafeRawProperty(name: "color", value: "var(--auth-primary-text)")
                    FontSize(1.5.rem)
                },
                Custom(".admin-page-header p") {
                    Margin(0.px)
                    UnsafeRawProperty(name: "color", value: "var(--auth-secondary-text)")
                },
                Custom(".new-admin-form") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(18.px)
                    Width(100.percent)
                    MarginTop(24.px)
                },
                Custom(".new-admin-form label") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(8.px)
                    UnsafeRawProperty(name: "color", value: "var(--auth-tertiary-text)")
                    Cursor(.pointer)
                },
                Custom(".new-admin-form input:not([type='checkbox'])") {
                    Width(100.percent)
                    Padding(vertical: 9.px, horizontal: 11.px)
                    BorderRadius(9.px)
                    UnsafeRawProperty(
                        name: "border",
                        value: "1px solid var(--auth-tertiary-border)"
                    )
                    UnsafeRawProperty(name: "color", value: "var(--auth-primary-text)")
                    UnsafeRawProperty(
                        name: "background",
                        value: "var(--auth-tertiary-tint)"
                    )
                    UnsafeRawProperty(name: "font", value: "inherit")
                    FontSize(1.rem)
                },
                Custom(
                    ".new-admin-form input:not([type='checkbox']):focus-visible"
                ) {
                    Outline(
                        2.px,
                        .solid,
                        .color(
                            .color(CSSColor(stringLiteral: "var(--auth-link-hover)"))
                        )
                    )
                    OutlineOffset(2.px)
                },
                Custom(".new-admin-form__actions") {
                    Display(.flex)
                    AlignItems(.stretch)
                    Gap(10.px)
                    FlexWrap(.wrap)
                    MarginTop(4.px)
                },
                Custom(".login-card .new-admin-form__actions") {
                    AlignItems(.stretch)
                },
                Custom(".button, .button:link, .button:visited, .button:hover, .button:active") {
                    Display(.inlineFlex)
                    AlignItems(.center)
                    JustifyContent(.center)
                    BoxSizing(.borderBox)
                    Padding(vertical: 10.px, horizontal: 16.px)
                    BorderRadius(999.px)
                    Border(.values(.length(1.px), .solid, .color(CSSColor(stringLiteral: "var(--auth-primary-border)"))))
                    UnsafeRawProperty(name: "color", value: "var(--auth-primary-text)")
                    UnsafeRawProperty(name: "background", value: "var(--auth-primary-tint)")
                    UnsafeRawProperty(name: "font", value: "inherit")
                    FontWeight(.number(700))
                    TextAlign(.center)
                    TextDecoration(.none)
                    Cursor(.pointer)
                    UnsafeRawProperty(
                        name: "transition",
                        value: "background-color 0.18s ease, border-color 0.18s ease, color 0.18s ease"
                    )
                },
                Custom(".button:focus-visible") {
                    Outline(
                        2.px,
                        .solid,
                        .color(
                            .color(CSSColor(stringLiteral: "var(--auth-link-hover)"))
                        )
                    )
                    OutlineOffset(2.px)
                },
                Custom(".button.primary") {
                    BorderColor(
                        .color(CSSColor(stringLiteral: "var(--auth-primary-accent-border)"))
                    )
                    UnsafeRawProperty(name: "color", value: "#fff")
                    UnsafeRawProperty(
                        name: "background",
                        value: "var(--auth-primary-accent)"
                    )
                },
                Custom(".button.primary:hover") {
                    UnsafeRawProperty(
                        name: "background",
                        value: "var(--auth-primary-accent-hover)"
                    )
                },
                Custom(".button.primary-ghost") {
                    UnsafeRawProperty(
                        name: "border-color",
                        value: "var(--auth-primary-ghost-border)"
                    )
                    UnsafeRawProperty(
                        name: "color",
                        value: "var(--auth-primary-ghost-text)"
                    )
                    UnsafeRawProperty(
                        name: "background",
                        value: "var(--auth-primary-ghost)"
                    )
                },
                Custom(".button.primary-ghost:hover") {
                    UnsafeRawProperty(
                        name: "background",
                        value: "var(--auth-primary-ghost-hover)"
                    )
                },
                Custom(".button.secondary-ghost") {
                    UnsafeRawProperty(
                        name: "border-color",
                        value: "var(--auth-secondary-ghost-border)"
                    )
                    UnsafeRawProperty(
                        name: "color",
                        value: "var(--auth-secondary-ghost-text)"
                    )
                    UnsafeRawProperty(
                        name: "background",
                        value: "var(--auth-secondary-ghost)"
                    )
                },
                Custom(".button.secondary-ghost:hover") {
                    UnsafeRawProperty(
                        name: "background",
                        value: "var(--auth-secondary-ghost-hover)"
                    )
                },
                Custom(".login-card .new-admin-form__actions .button") {
                    Width(100.percent)
                },
                Custom(".new-admin-form__error, .new-admin-form__success") {
                    Margin(0.px)
                    Padding(vertical: 12.px, horizontal: 14.px)
                    BorderRadius(8.px)
                    Border(.values(.length(1.px), .solid, .transparent))
                },
                Custom(".new-admin-form__error") {
                    BorderColor(
                        .color(CSSColor(stringLiteral: "var(--auth-error-border)"))
                    )
                    UnsafeRawProperty(name: "color", value: "var(--auth-error-text)")
                    UnsafeRawProperty(
                        name: "background",
                        value: "var(--auth-error-background)"
                    )
                    LineHeight(1.4)
                },
                Custom(".new-admin-form__success") {
                    BorderColor(
                        .color(CSSColor(stringLiteral: "var(--auth-success-border)"))
                    )
                    UnsafeRawProperty(name: "color", value: "var(--auth-success-text)")
                    UnsafeRawProperty(
                        name: "background",
                        value: "var(--auth-success-background)"
                    )
                },
                Custom(".new-admin-form__hint") {
                    Margin(0.px)
                    UnsafeRawProperty(name: "color", value: "var(--auth-tertiary-text)")
                    FontSize(0.875.rem)
                    LineHeight(1.45)
                },
                Custom(".login-actions") {
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
                Section {
                    Header {
                        H1(success == nil ? "Create account" : "Account created")
                            .id("page-title")
                        P(
                            success == nil
                                ? "Complete your invited account registration."
                                : "Your invitation is complete. Sign in to continue to the admin."
                        )
                    }
                    .class("admin-page-header")

                    if let success {
                        P(success)
                            .class("new-admin-form__success")
                            .role("status")
                    }
                    else {
                        Form {
                            Input().type(.hidden).name("token").value(token)
                            if let error {
                                P(error)
                                    .class("new-admin-form__error")
                                    .role("alert")
                            }
                            if let email {
                                Label {
                                    Span("Email address")
                                    Input()
                                        .type(.email)
                                        .value(email)
                                        .readOnly()
                                        .autocomplete("username")
                                }
                            }
                            Label {
                                Span("Password")
                                Input()
                                    .type(.password)
                                    .name("password")
                                    .value(password)
                                    .autocomplete("new-password")
                                    .required()
                            }
                            Label {
                                Span("Confirm password")
                                Input()
                                    .type(.password)
                                    .name("confirmation")
                                    .value(confirmation)
                                    .autocomplete("new-password")
                                    .required()
                            }
                            P(
                                "Use at least 8 characters. You can use this password to sign in after registration."
                            )
                                .class("new-admin-form__hint")
                            Div {
                                Button("Create account")
                                    .type(.submit)
                                    .class("button primary")
                            }
                            .class("new-admin-form__actions")
                        }
                        .action(action)
                        .method(.post)
                        .class("new-admin-form")
                    }

                    Nav {
                        A("Already have an account?")
                            .href(loginPath)
                            .class("button primary-ghost")
                        A("Home")
                            .href("/")
                            .class("button secondary-ghost")
                    }
                    .class("login-actions")
                    .ariaLabel("Other account actions")
                }
                .class("login-card")
                .ariaLabelledBy("page-title")
            }
            .class("login-page")
        }
    }
}
