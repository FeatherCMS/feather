import AuthAppAPI
import CSS
import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import WebBuilders
import WebComponents

struct AppMagicLink {

    struct RequestInput: Codable, Sendable {
        let email: String
        let isPersistent: NewAdminFormFieldCheckbox.Input

        enum CodingKeys: String, CodingKey {
            case email
            case isPersistent = "is_persistent"
        }
    }

    struct Page: Component {
        let email: String
        let isPersistent: Bool
        let error: String?
        let message: String?

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
                Custom(".login-card .new-admin-form") {
                    MarginTop(24.px)
                },
                Custom(".login-card .new-admin-form__actions") {
                    AlignItems(.stretch)
                },
                Custom(".login-card .new-admin-form__actions .button") {
                    Width(100.percent)
                },
                Custom(".login-card .new-admin-form__success") {
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
                                description:
                                    "Enter your email to receive a sign-in link."
                            )
                        )
                    )

                    context.build(
                        NewAdminForm(action: "/magic-link/") {
                            if let message {
                                P(message).class("new-admin-form__success")
                            }
                            if let error {
                                P(error).class("new-admin-form__error")
                            }
                            context.build(
                                NewAdminFormFieldInput(
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
                                NewAdminFormFieldCheckbox(
                                    state: .init(
                                        name: "is_persistent",
                                        label: "Session",
                                        checkboxLabel: "Permanent link",
                                        isChecked: isPersistent
                                    )
                                )
                            )
                            Div {
                                context.build(
                                    NewAdminSubmitButton("Send magic link")
                                )
                            }
                            .class("new-admin-form__actions")
                        }
                    )

                    Div {
                        context.build(
                            NewAdminButton(
                                "Sign in with credentials",
                                href: "/login/",
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

    let renderingEngine: any RenderingEngine

    func getRequest(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        var buildContext = BuilderContext()
        return render(
            request: request,
            email: "",
            isPersistent: true,
            error: nil,
            message: nil,
            context: &buildContext
        )
    }

    func postRequest(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        var buildContext = BuilderContext()
        let input = try await request.decode(
            as: RequestInput.self,
            context: context
        )
        do {
            let response = try await context.authAppAPI()
                .withOpenAPIRepositoryErrorMapping { client in
                    try await client.authMagicLink(
                        body: .json(
                            .init(
                                email: input.email,
                                isPersistent: input.isPersistent.value
                            )
                        )
                    )
                }
            switch response {
            case .noContent:
                return render(
                    request: request,
                    email: input.email,
                    isPersistent: input.isPersistent.value,
                    error: nil,
                    message: "If registered, your sign-in link is on its way.",
                    context: &buildContext
                )
            case .undocumented(let statusCode, let response):
                throw try await context.authAppAPI()
                    .failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
            }
        }
        catch let error as OpenAPIRepositoryError {
            return render(
                request: request,
                email: input.email,
                isPersistent: input.isPersistent.value,
                error: error.errorDescription,
                message: nil,
                context: &buildContext
            )
        }
    }

    func verify(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        var buildContext = BuilderContext()
        let token = request.uri.queryParameters["token"].map(String.init) ?? ""
        do {
            let response = try await context.authAppAPI()
                .withOpenAPIRepositoryErrorMapping { client in
                    try await client.authMagicLinkVerify(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(.init(token: token))
                    )
                }
            switch response {
            case .ok(let ok):
                let result = try ok.body.json
                let cookie = Cookie(
                    name: "session_token",
                    value: result.token,
                    path: "/",
                    secure: unsafe AppEnvironmentStore.current.publicOrigins
                        .usesSecureCookies,
                    httpOnly: true,
                    sameSite: .lax
                )
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: "/",
                        .setCookie: cookie.description,
                    ]
                )
            case .unauthorized:
                return try render(
                    request: request,
                    email: "",
                    isPersistent: true,
                    error:
                        "This magic link is invalid, expired, or has already been used.",
                    message: nil,
                    context: &buildContext
                )
                .response(from: request, context: context)
            case .undocumented(let statusCode, let response):
                throw try await context.authAppAPI()
                    .failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
            }
        }
        catch let error as OpenAPIRepositoryError {
            return try render(
                request: request,
                email: "",
                isPersistent: true,
                error: error.errorDescription,
                message: nil,
                context: &buildContext
            )
            .response(from: request, context: context)
        }
    }

    private func render(
        request: Request,
        email: String,
        isPersistent: Bool,
        error: String?,
        message: String?,
        context: inout BuilderContext
    ) -> HTMLResponse {
        let component = NewAdminHTML(
            title: "Magic link",
            body: .init(
                content: Page(
                    email: email,
                    isPersistent: isPersistent,
                    error: error,
                    message: message
                ),
                showsFooter: false,
                allowsPasswordManagerAutofill: true
            ),
            stylesheetPath: nil
        )
        return .init(context.build(component))
    }

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get("/magic-link/", use: getRequest)
        router.post("/magic-link/", use: postRequest)
        router.get("/magic-link/verify/", use: verify)
    }
}
