import AccountAppAPI
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

        func html(context: inout BuilderContext) -> Section {
            Section {
                H1("Create your account")
                if let success {
                    P(success).class("success")
                    context.build(
                        NewAdminButton(
                            "Go to login",
                            href: "/login/",
                            style: .ghost(.primary)
                        )
                    )
                }
                else {
                    P("Complete your registration using the invitation.")
                    if let email { P("Invitation for \(email).") }
                    if let error { P(error).class("error") }
                    Form {
                        Input().type(.hidden).name("token").value(token)
                        context.build(
                            NewAdminFormFieldInput(
                                state: .init(
                                    name: "password",
                                    label: "Password",
                                    value: password,
                                    type: .password
                                )
                            )
                        )
                        context.build(
                            NewAdminFormFieldInput(
                                state: .init(
                                    name: "confirmation",
                                    label: "Confirm password",
                                    value: confirmation,
                                    type: .password
                                )
                            )
                        )
                        Button("Create account").type(.submit)
                    }
                    .method(.post)
                    .action("/account/invitation/accept/")
                    .encType(.urlencoded)
                    .class("cms-form")
                }
            }
            .class("cms-section")
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
        var buildContext = BuilderContext()
        let token = request.uri.queryParameters["token"].map(String.init) ?? ""
        guard !token.isEmpty else {
            return render(
                request: request,
                token: "",
                email: nil,
                password: "",
                confirmation: "",
                error: "Invitation token is missing.",
                success: nil,
                context: &buildContext
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
                    success: nil,
                    context: &buildContext
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
                success: nil,
                context: &buildContext
            )
        }
    }

    func post(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        var buildContext = BuilderContext()
        let payload = try await request.decode(
            as: FormInput.self,
            context: context
        )
        guard payload.password.count >= 8 else {
            return render(
                request: request,
                token: request.uri.queryParameters["token"].map(String.init)
                    ?? "",
                email: nil,
                password: payload.password,
                confirmation: payload.confirmation,
                error: "Password must contain at least 8 characters.",
                success: nil,
                context: &buildContext
            )
        }
        guard payload.password == payload.confirmation else {
            return render(
                request: request,
                token: request.uri.queryParameters["token"].map(String.init)
                    ?? "",
                email: nil,
                password: payload.password,
                confirmation: payload.confirmation,
                error: "Passwords do not match.",
                success: nil,
                context: &buildContext
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
                        "Your account was created successfully. You can now sign in.",
                    context: &buildContext
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
                success: nil,
                context: &buildContext
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
        success: String?,
        context: inout BuilderContext
    ) -> HTMLResponse {

        renderingEngine.renderPublicPage(
            request: request,
            title: "Create account",
            description: "Complete your invited account registration.",
            imagePath: "images/puppy.png",
            content: context.build(
                Page(
                    token: token,
                    email: email,
                    password: password,
                    confirmation: confirmation,
                    error: error,
                    success: success
                )
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
