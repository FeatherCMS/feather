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
                    Margin(0.px)
                    Color(.color("#1f2937"))
                    BackgroundColor(.color("#f4f1fb"))
                },
                Custom("main") {
                    Display(.flex)
                    AlignItems(.center)
                    JustifyContent(.center)
                    BoxSizing(.borderBox)
                    MinHeight(100.vh)
                    Padding(vertical: 32.px, horizontal: 20.px)
                    BackgroundColor(.color("#f4f1fb"))
                },
                Custom(".invitation-card") {
                    Width(100.percent)
                    MaxWidth(460.px)
                    BoxSizing(.borderBox)
                    Padding(36.px)
                    Border(.values(.length(1.px), .solid, .color("#e5def0")))
                    BorderRadius(24.px)
                    BackgroundColor(.color("#ffffff"))
                    BoxShadow(
                        0.px,
                        18.px,
                        blur: 44.px,
                        spread: 0.px,
                        color: CSSColor(stringLiteral: "#30204a18")
                    )
                },
                Custom(".invitation-brand") {
                    Margin(0.px)
                    Color(.color("#6536ab"))
                    FontSize(0.75.rem)
                    FontWeight(.number(700))
                },
                Custom(".invitation-card h1") {
                    Margin(top: 12.px, bottom: 8.px)
                    Color(.color("#181321"))
                    FontSize(1.8.rem)
                    FontWeight(.number(700))
                },
                Custom(".invitation-description") {
                    Margin(0.px)
                    Color(.color("#5f596a"))
                    LineHeight(1.5)
                },
                Custom(".invitation-card form") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(.length(18.px), .length(18.px))
                    MarginTop(28.px)
                },
                Custom(".invitation-card label") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(.length(9.px), .length(9.px))
                    Color(.color("#343041"))
                    FontWeight(.number(600))
                },
                Custom(
                    ".invitation-card input:not([type='hidden'])"
                ) {
                    BoxSizing(.borderBox)
                    Width(100.percent)
                    Padding(vertical: 13.px, horizontal: 14.px)
                    Border(.values(.length(1.px), .solid, .color("#d8d1e2")))
                    BorderRadius(10.px)
                    BackgroundColor(.color("#fcfbfe"))
                    FontSize(1.rem)
                },
                Custom(".invitation-card button, .invitation-card a") {
                    Border(0)
                    BorderRadius(999.px)
                    Padding(vertical: 13.px, horizontal: 18.px)
                    BackgroundColor(.color("#6536ab"))
                    Color(.white)
                    FontSize(1.rem)
                    FontWeight(.number(700))
                    TextAlign(.center)
                    TextDecoration(.none)
                    Cursor(.pointer)
                },
                Custom(".invitation-card button") {
                    Width(100.percent)
                },
                Custom(
                    ".invitation-card button:hover, .invitation-card a:hover"
                ) {
                    BackgroundColor(.color("#4b2780"))
                },
                Custom(".invitation-actions") {
                    Display(.flex)
                    MarginTop(4.px)
                },
                Custom(".invitation-success") {
                    Margin(top: 28.px)
                    Padding(vertical: 12.px, horizontal: 14.px)
                    BorderRadius(8.px)
                    Border(.values(.length(1.px), .solid, .color("#86efac")))
                    BackgroundColor(.color("#f0fdf4"))
                    Color(.color("#166534"))
                },
                Custom(".invitation-error") {
                    Margin(0.px)
                    Padding(vertical: 12.px, horizontal: 14.px)
                    BorderRadius(8.px)
                    Border(.values(.length(1.px), .solid, .color("#fecaca")))
                    BackgroundColor(.color("#fef2f2"))
                    Color(.color("#991b1b"))
                    LineHeight(1.4)
                },
                Custom(".invitation-email") {
                    Margin(top: 22.px)
                    Padding(vertical: 12.px, horizontal: 14.px)
                    BorderRadius(10.px)
                    BackgroundColor(.color("#f7f4fb"))
                    Color(.color("#4b4454"))
                    LineHeight(1.4)
                },
                Custom(".invitation-hint") {
                    Margin(top: 0.px)
                    Color(.color("#716a7d"))
                    FontSize(0.875.rem)
                    LineHeight(1.45)
                },
            ]
        }

        func html(context: inout BuilderContext) -> Main {
            Main {
                Div {
                    P("FEATHER · ACCOUNT INVITATION")
                        .class("invitation-brand")
                    H1(
                        success == nil
                            ? "Create your account" : "Account created"
                    )
                    P(
                        success == nil
                            ? "Complete your registration using the invitation."
                            : "Your invitation is complete. Sign in to continue to the admin."
                    ).class("invitation-description")

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
                                P(error).class("invitation-error")
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
                            P(
                                "Use at least 8 characters. You can use this password to sign in after registration."
                            )
                                .class("invitation-hint")
                            Div {
                                Button("Create account").type(.submit)
                            }.class("invitation-actions")
                        }
                        .action(action)
                        .method(.post)
                    }
                }
                .class("invitation-card")
                .role("main")
            }
        }
    }
}
