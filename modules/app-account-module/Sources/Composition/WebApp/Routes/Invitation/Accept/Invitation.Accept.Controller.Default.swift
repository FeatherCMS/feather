import AccountAppAPI
import AccountModule
import FeatherWebApp
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

extension Invitation.Accept.Controller {
    struct Default: Interface {
        let environment: AppEnvironment
        let pageRenderer: any PublicPageRenderer
        let routes: Invitation.Accept.Router.Routes

        func get(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response {
            let token =
                request.uri.queryParameters["token"].map(String.init)
                ?? ""
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
                case AccountAppAPI.Operations.AccountInvitationValidate.Output
                    .ok(
                        let
                            value
                    ):
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
                case AccountAppAPI.Operations.AccountInvitationValidate.Output
                    .undocumented(let statusCode, let response):
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
            catch {
                return render(
                    request: request,
                    token: token,
                    email: nil,
                    password: "",
                    confirmation: "",
                    error: (error as? OpenAPIRepositoryError)?.errorDescription
                        ?? String(describing: error),
                    success: nil
                )
            }
        }

        func post(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response {
            let payload = try await request.decode(
                as: Invitation.Accept.Form.Input.self,
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
                                headers: .init(accept: [
                                    .init(contentType: .json)
                                ]),
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
                case AccountAppAPI.Operations.AccountInvitationExchange.Output
                    .ok(_):
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
                case AccountAppAPI.Operations.AccountInvitationExchange.Output
                    .undocumented(let statusCode, let response):
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
            catch {
                return render(
                    request: request,
                    token: payload.token,
                    email: nil,
                    password: payload.password,
                    confirmation: payload.confirmation,
                    error: (error as? OpenAPIRepositoryError)?.errorDescription
                        ?? String(describing: error),
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
            pageRenderer.render(
                request: request,
                title: success == nil ? "Create account" : "Account created",
                description: success == nil
                    ? "Complete your invited account registration."
                    : "Your invitation is complete. Sign in to continue to the admin.",
                imagePath: "images/puppy.png",
                content: Invitation.Accept.View.Page(
                    action: routes.accept.path,
                    token: token,
                    email: email,
                    password: password,
                    confirmation: confirmation,
                    error: error,
                    success: success
                )
            )
        }
    }
}
