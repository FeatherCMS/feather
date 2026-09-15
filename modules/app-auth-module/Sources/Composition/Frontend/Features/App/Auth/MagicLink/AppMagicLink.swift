import AuthAppAPI
import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
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
        let token: String?
        let email: String
        let isPersistent: Bool
        let error: String?
        let message: String?

        func html(context: inout BuilderContext) -> Section {
            Section {
                H1(token == nil ? "Request a magic link" : "Signing in")
                if let message { P(message).class("success") }
                if let error { P(error).class("error") }
                if token == nil {
                    Form {
                        context.build(
                            NewAdminFormFieldInput(
                                state: .init(
                                    name: "email",
                                    label: "Email address",
                                    value: email,
                                    type: .email
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
                        Button("Send magic link").type(.submit)
                    }
                    .method(.post)
                    .action("/magic-link/")
                    .encType(.urlencoded)
                    .class("cms-form")
                }
            }
            .class("cms-section")
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
                    message:
                        "If the account exists, a magic link has been sent.",
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
                    secure: AppEnvironmentStore.current.publicOrigins
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

        renderingEngine.renderPublicPage(
            request: request,
            title: "Magic link",
            description: "Sign in without a password using a magic link.",
            imagePath: "images/puppy.png",
            content: context.build(
                Page(
                    token: nil,
                    email: email,
                    isPersistent: isPersistent,
                    error: error,
                    message: message
                )
            )
        )
    }

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get("/magic-link/", use: getRequest)
        router.post("/magic-link/", use: postRequest)
        router.get("/magic-link/verify/", use: verify)
    }
}
