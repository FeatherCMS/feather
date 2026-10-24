import AccountModule
import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

extension Invitation.Accept.View {
    struct Page: Component {
        let action: String
        let token: String
        let email: String?
        let password: String
        let confirmation: String
        let error: String?
        let success: String?

        func rules() -> [any Rule] { [Media(selectors: selectors())] }

        func selectors() -> [any Selector] {
            [
                Custom("body") {
                    BackgroundColor(.color("#f3f4f6"))
                },
                Custom("main") {
                    Display(.flex)
                    AlignItems(.center)
                    JustifyContent(.center)
                    BoxSizing(.borderBox)
                    MinHeight(100.vh)
                    Padding(vertical: 32.px, horizontal: 20.px)
                    BackgroundColor(.color("#f3f4f6"))
                },
                Custom("main > div") {
                    Width(100.percent)
                    MaxWidth(440.px)
                    BoxSizing(.borderBox)
                    Padding(32.px)
                    Border(.values(.length(1.px), .solid, .color("#d1d5db")))
                    BorderRadius(20.px)
                    BackgroundColor(.color("#ffffff"))
                    BoxShadow(
                        0.px,
                        12.px,
                        blur: 26.px,
                        spread: 2.px,
                        color: CSSColor(stringLiteral: "#00000020")
                    )
                },
                Custom("main > div h1") {
                    Margin(bottom: 8.px)
                },
                Custom("main > div form") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(.length(16.px), .length(16.px))
                    MarginTop(24.px)
                },
                Custom("main > div label") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(.length(8.px), .length(8.px))
                },
                Custom(
                    "main > div input:not([type='hidden']), main > div button, main > div a"
                ) {
                    BoxSizing(.borderBox)
                    Width(100.percent)
                    Padding(vertical: 12.px, horizontal: 14.px)
                    Border(.values(.length(1.px), .solid, .color("#9ca3af")))
                    BorderRadius(8.px)
                    FontSize(1.rem)
                },
                Custom("main > div button, main > div a") {
                    Border(0)
                    BackgroundColor(.color("#005cff"))
                    Color(.white)
                    TextAlign(.center)
                    TextDecoration(.none)
                    Cursor(.pointer)
                },
                Custom("main > div > div") {
                    Display(.flex)
                    AlignItems(.stretch)
                    MarginTop(24.px)
                },
                Custom(".invitation-success") {
                    Margin(top: 24.px)
                    Padding(vertical: 12.px, horizontal: 14.px)
                    BorderRadius(8.px)
                    Border(.values(.length(1.px), .solid, .color("#86efac")))
                    BackgroundColor(.color("#f0fdf4"))
                    Color(.color("#166534"))
                },
                Custom(".invitation-email") {
                    Color(.color("#4b5563"))
                },
            ]
        }

        func html(context: inout BuilderContext) -> Main {
            Main {
                Div {
                    H1(
                        success == nil
                            ? "Create your account" : "Account created"
                    )
                    P(
                        success == nil
                            ? "Complete your registration using the invitation."
                            : "Your invitation is complete. Sign in to continue to the admin."
                    )

                    if let success {
                        P(success).class("invitation-success")
                        Div {
                            A("Continue to admin")
                                .href("/login/?redirect=%2Fadmin%2F")
                        }
                    }
                    else {
                        Form {
                            Input().type(.hidden).name("token").value(token)
                            if let email {
                                P("Invitation for \(email).")
                                    .class("invitation-email")
                            }
                            if let error {
                                P(error).class("admin-form__error")
                            }
                            Label {
                                "Password"
                                Input().type(.password).name("password")
                                    .value(password).required()
                            }
                            Label {
                                "Confirm password"
                                Input().type(.password).name("confirmation")
                                    .value(confirmation).required()
                            }
                            Div {
                                Button("Create account").type(.submit)
                            }
                        }
                        .action(action)
                        .method(.post)
                    }
                }
                .role("main")
            }
        }
    }
}
