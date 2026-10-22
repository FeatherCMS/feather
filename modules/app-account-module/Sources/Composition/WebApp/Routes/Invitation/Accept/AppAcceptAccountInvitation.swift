import AccountAppAPI
import CSS
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AppAcceptAccountInvitation {
    let environment: AppEnvironment

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
                        .action("/account/invitation/accept/")
                        .method(.post)
                    }
                }
                .role("main")
            }
        }
    }

    let renderingEngine: any PublicPageRendering

    func get(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
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
            let response =
                try await API.Client(
                    environment: environment,
                    requestContext: context
                )
                .withOpenAPIRepositoryErrorMapping { client in
                    try await client.accountInvitationValidate(
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
                throw
                    try await API.Client(
                        environment: environment,
                        requestContext: context
                    )
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
    ) async throws -> Response {
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
            let response =
                try await API.Client(
                    environment: environment,
                    requestContext: context
                )
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
                throw
                    try await API.Client(
                        environment: environment,
                        requestContext: context
                    )
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
    ) -> Response {
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
        on router: any RouterMethods<DefaultRequestContext>
    ) {
        router.get("/account/invitation/accept/", use: get)
        router.post("/account/invitation/accept/", use: post)
    }
}
