import AccountAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AppAcceptAccountInvitation {

    struct FormInput: Codable, Sendable {
        let token: String
        let password: String
        let confirmation: String
    }

    struct Page: Leaf {
        let token: String
        let email: String?
        let password: String
        let confirmation: String
        let error: String?
        let success: String?

        func renderHTML() -> Section {
            Section {
                H1("Create your account")
                if let success {
                    P(success).class("success")
                    AdminNavigationButton("Go to login", href: "/login/").renderHTML()
                }
                else {
                    P("Complete your registration using the invitation.")
                    if let email { P("Invitation for \(email).") }
                    if let error { P(error).class("error") }
                    Form {
                        Input().type(.hidden).name("token").value(token)
                        PasswordField(
                            state: .init(
                                key: "password",
                                label: "Password",
                                value: password
                            )
                        ).renderHTML()
                        PasswordField(
                            state: .init(
                                key: "confirmation",
                                label: "Confirm password",
                                value: confirmation
                            )
                        ).renderHTML()
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
            let response = try await context.accountAppAPI()
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
                throw try await context.accountAppAPI()
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
                token: request.uri.queryParameters["token"].map(String.init)
                    ?? "",
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
                token: request.uri.queryParameters["token"].map(String.init)
                    ?? "",
                email: nil,
                password: payload.password,
                confirmation: payload.confirmation,
                error: "Passwords do not match.",
                success: nil
            )
        }
        do {
            let response = try await context.accountAppAPI()
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
                throw try await context.accountAppAPI()
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
        renderingEngine.renderPage(
            request: request,
            title: "Create account",
            description: "Complete your invited account registration.",
            imagePath: "images/puppy.png",
            content: Page(
                token: token,
                email: email,
                password: password,
                confirmation: confirmation,
                error: error,
                success: success
            ).renderHTML()
        )
    }

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get("/account/invitation/accept/", use: get)
        router.post("/account/invitation/accept/", use: post)
    }
}
