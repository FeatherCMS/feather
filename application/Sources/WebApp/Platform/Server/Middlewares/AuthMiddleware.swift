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
        let path = request.uri.path

        if path.hasPrefix("/.well-known") || path.hasSuffix("favicon.ico") {
            return try await next(request, context)
        }

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
            let shouldClearSession = error.httpStatus.code == 500
            let userAgent = request.headers[.userAgent] ?? "-"
            let referer = request.headers[.referer] ?? "-"
            let origin = request.headers[.origin] ?? "-"
            let secFetchSite = request.headers[.init("Sec-Fetch-Site")!] ?? "-"
            let secFetchMode = request.headers[.init("Sec-Fetch-Mode")!] ?? "-"
            let secFetchDest = request.headers[.init("Sec-Fetch-Dest")!] ?? "-"

            print("==== SESSION ERROR ====")
            print("Request: \(request.method) \(request.uri)")
            print("User-Agent: \(userAgent)")
            print("Referer: \(referer)")
            print("Origin: \(origin)")
            print("Sec-Fetch-Site: \(secFetchSite)")
            print("Sec-Fetch-Mode: \(secFetchMode)")
            print("Sec-Fetch-Dest: \(secFetchDest)")
            print("\(type(of: error))")
            print("\(error)")

            var response = try await next(request, context)
            if shouldClearSession {
                response.setCookie(
                    Cookie(
                        name: "session_token",
                        value: "",
                        maxAge: 0,
                        path: "/",
                        secure: AppEnvironmentStore.current.publicOrigins
                            .usesSecureCookies,
                        httpOnly: true,
                        sameSite: .lax
                    )
                )
            }
            return response
        }
        return try await next(request, context)
    }
}
