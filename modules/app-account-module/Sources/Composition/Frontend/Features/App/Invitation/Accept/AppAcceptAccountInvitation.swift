import AccountAppAPI
import CSS
import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import WebBuilders
import WebComponents

struct AppAcceptAccountInvitation {
    let apiBuilder: AccountAPIBuilder

    struct FormInput: Codable, Sendable {
        let token: String
        let password: String
        let confirmation: String
    }

    struct Page: Component {
        let token: String
        let email: String?
        let password: String
        let confirmation: String
        let error: String?
        let success: String?

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
                Class("invitation-page") {
                    Display(.flex)
                    AlignItems(.center)
                    JustifyContent(.center)
                    BoxSizing(.borderBox)
                    MinHeight(100.vh)
                    Padding(vertical: 32.px, horizontal: 20.px)
                    Background(
                        .variable(TokenKey.Colors.Materials.Secondary.tint)
                    )
                },
                Class("invitation-card") {
                    Width(100.percent)
                    MaxWidth(440.px)
                    BoxSizing(.borderBox)
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
                Custom(".invitation-card .admin-page-header") {
                    Margin(bottom: 0.px)
                },
                Custom(".invitation-card .new-admin-form") {
                    MarginTop(24.px)
                },
                Custom(".invitation-card .new-admin-form__actions") {
                    AlignItems(.stretch)
                },
                Custom(
                    ".invitation-card .new-admin-form__actions .button, "
                        + ".invitation-actions .button"
                ) {
                    Width(100.percent)
                },
                Class("invitation-actions") {
                    Display(.flex)
                    AlignItems(.stretch)
                    MarginTop(24.px)
                },
                Class("invitation-success") {
                    Margin(top: 24.px)
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
                Class("invitation-email") {
                    Color(
                        .variable(TokenKey.Colors.Materials.Tertiary.text)
                    )
                },
            ]
        }

        func html(context: inout BuilderContext) -> Main {
            Main {
                Div {
                    context.build(
                        NewAdminPageHeader(
                            state: .primary(
                                title: success == nil
                                    ? "Create your account" : "Account created",
                                description: success == nil
                                    ? "Complete your registration using the invitation."
                                    : "Your invitation is complete. Sign in to continue to the admin."
                            )
                        )
                    )

                    if let success {
                        P(success).class("invitation-success")
                        Div {
                            context.build(
                                NewAdminButton(
                                    "Continue to admin",
                                    href: "/login/?redirect=%2Fadmin%2F",
                                    style: .primary
                                )
                            )
                        }
                        .class("invitation-actions")
                    }
                    else {
                        context.build(
                            NewAdminForm(
                                action: "/account/invitation/accept/",
                                hiddenFields: [
                                    .init(name: "token", value: token)
                                ]
                            ) {
                                if let email {
                                    P("Invitation for \(email).")
                                        .class("invitation-email")
                                }
                                if let error {
                                    P(error).class("new-admin-form__error")
                                }
                                context.build(
                                    NewAdminFormFieldInput(
                                        state: .init(
                                            name: "password",
                                            label: "Password",
                                            value: password,
                                            type: .password,
                                            isRequired: true
                                        )
                                    )
                                )
                                context.build(
                                    NewAdminFormFieldInput(
                                        state: .init(
                                            name: "confirmation",
                                            label: "Confirm password",
                                            value: confirmation,
                                            type: .password,
                                            isRequired: true
                                        )
                                    )
                                )
                                Div {
                                    context.build(
                                        NewAdminSubmitButton("Create account")
                                    )
                                }
                                .class("new-admin-form__actions")
                            }
                        )
                    }
                }
                .class("invitation-card")
            }
            .class("invitation-page")
            .role("main")
        }
    }

    let renderingEngine: any RenderingEngine

    init(apiBuilder: AccountAPIBuilder, renderingEngine: any RenderingEngine) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
    }

    func get(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let token = request.uri.queryParameters["token"].map(String.init) ?? ""
        guard !token.isEmpty else {
            return render(
                request: request,
                token: "",
                email: nil,
                password: "",
                confirmation: "",
                error: "Invitation token is missing.",
                success: nil
            )
        }
        do {
            let response = try await apiBuilder.makeAccountApp(context)
                .withOpenAPIRepositoryErrorMapping { client in
                    try await client.accountInvitationValidation(
                        query: .init(token: token),
                        headers: .init(accept: [.init(contentType: .json)])
                    )
                }
            switch response {
            case .ok(let value):
                let body = try value.body.json
                return render(
                    request: request,
                    token: token,
                    email: body.email,
                    password: "",
                    confirmation: "",
                    error: nil,
                    success: nil
                )
            case .undocumented(let statusCode, let response):
                throw try await apiBuilder.makeAccountApp(context)
                    .failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
            }
        }
        catch let error as OpenAPIRepositoryError {
            return render(
                request: request,
                token: token,
                email: nil,
                password: "",
                confirmation: "",
                error: error.errorDescription,
                success: nil
            )
        }
    }

    func post(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let payload = try await request.decode(
            as: FormInput.self,
            context: context
        )
        guard payload.password.count >= 8 else {
            return render(
                request: request,
                token: payload.token,
                email: nil,
                password: payload.password,
                confirmation: payload.confirmation,
                error: "Password must contain at least 8 characters.",
                success: nil
            )
        }
        guard payload.password == payload.confirmation else {
            return render(
                request: request,
                token: payload.token,
                email: nil,
                password: payload.password,
                confirmation: payload.confirmation,
                error: "Passwords do not match.",
                success: nil
            )
        }
        do {
            let response = try await apiBuilder.makeAccountApp(context)
                .withOpenAPIRepositoryErrorMapping { client in
                    try await client.accountInvitationExchange(
                        .init(
                            headers: .init(accept: [.init(contentType: .json)]),
                            body: .json(
                                .init(
                                    token: payload.token,
                                    password: payload.password
                                )
                            )
                        )
                    )
                }
            switch response {
            case .ok:
                return render(
                    request: request,
                    token: payload.token,
                    email: nil,
                    password: "",
                    confirmation: "",
                    error: nil,
                    success:
                        "Your account was created successfully. You can now sign in."
                )
            case .undocumented(let statusCode, let response):
                throw try await apiBuilder.makeAccountApp(context)
                    .failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
            }
        }
        catch let error as OpenAPIRepositoryError {
            return render(
                request: request,
                token: payload.token,
                email: nil,
                password: payload.password,
                confirmation: payload.confirmation,
                error: error.errorDescription,
                success: nil
            )
        }
    }

    private func render(
        request: Request,
        token: String,
        email: String?,
        password: String,
        confirmation: String,
        error: String?,
        success: String?
    ) -> HTMLResponse {
        renderingEngine.renderPublicPage(
            request: request,
            title: success == nil ? "Create account" : "Account created",
            description: success == nil
                ? "Complete your invited account registration."
                : "Your invitation is complete. Sign in to continue to the admin.",
            imagePath: "images/puppy.png",
            content: Page(
                token: token,
                email: email,
                password: password,
                confirmation: confirmation,
                error: error,
                success: success
            )
        )
    }

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get("/account/invitation/accept/", use: get)
        router.post("/account/invitation/accept/", use: post)
    }
}
