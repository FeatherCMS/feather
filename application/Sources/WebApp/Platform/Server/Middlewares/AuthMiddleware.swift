import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import FeatherAdmin
import AuthAppAPI
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
        next: @concurrent (Request, AppRequestContext) async throws -> Response
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
                .withAuthOpenAPIRepositoryErrorMapping { client in
                    let response = try await client.authMe()

                    let payload = try response.ok.body.json
                    return AccountModel(
                        user: .init(
                            id: payload.user.id,
                            email: ""
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
