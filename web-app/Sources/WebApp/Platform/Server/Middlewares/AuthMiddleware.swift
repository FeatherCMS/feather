//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 01..
//

import Hummingbird

struct AuthMiddleware: RouterMiddleware {

    func handle(
        _ request: Request,
        context: AppRequestContext,
        next: (Request, AppRequestContext) async throws -> Response
    ) async throws -> HummingbirdCore.Response {
        guard
            let sessionToken = request.cookies["session_token"]?.value,
            !sessionToken.isEmpty
        else {
            return try await next(request, context)
        }

        var context = context
        context.sessionToken = sessionToken

        do {
            let account = try await context.applicationAPI()
                .withOpenAPIRepositoryErrorMapping { client in
                    let response = try await client.authMe()

                    switch response {
                    case .undocumented(statusCode: let code, let payload):
                        var buffer: ByteBuffer = .init()
                        try await payload.body?
                            .collect(upTo: .max, into: &buffer)
                        let message =
                            buffer.getString(
                                at: 0,
                                length: buffer.readableBytes
                            )
                            ?? "<non-utf8 payload>"
                        print(
                            "buffer",
                            code,
                            message
                        )
                    default:
                        break
                    }

                    let payload = try response.ok.body.json
                    return AccountModel(
                        user: .init(
                            id: payload.user.id,
                            email: payload.user.email
                        ),
                        permissions: payload.permissions,
                        roles: payload.roles
                    )
                }
            context.account = account
        }
        catch {
            print("==== SESSION ERROR ====")
            print("\(type(of: error))")
            print("\(error)")
        }
        return try await next(request, context)
    }
}
