import FeatherApplication
import AuthApplication
import Hummingbird
import OpenAPIRuntime
import OpenAPIHummingbird
import Logging
import SystemAdminAPI
import SystemAppAPI
import UserAdminAPI
import UserAppAPI
import AccountAdminAPI
import AccountAppAPI
import RedirectAdminAPI
import RedirectAppAPI
import AnalyticsAdminAPI
import AnalyticsAppAPI
import AnalyticsBackend
import WebAdminAPI
import WebAppAPI
import WebBackend
import NewsletterAdminAPI
import NewsletterAppAPI
import NewsletterBackend
import ContactAdminAPI
import ContactAppAPI
import ContactBackend
import MediaBackend
import MediaAdminAPI
import BlogAdminAPI
import BlogAppAPI
import BlogBackend
import NewsAppAPI
import NewsBackend
import SystemBackend
import RedirectBackend
import UserBackend
import AccountBackend
import AuthBackend
import AuthAdminAPI
import AuthAppAPI

func buildRouter(
    modules: AppModules
) throws -> Router<AppRequestContext> {
    let router = Router(context: AppRequestContext.self)

    router.addMiddleware {
        // LOG
        LogRequestsMiddleware(.info)
        // CORS
        CORSMiddleware(
            allowOrigin: .originBased,
            allowHeaders: [
                .accept,
                .acceptLanguage,
                .accessControlAllowOrigin,
                .accessControlAllowCredentials,
                .authorization,
                .cacheControl,
                .connection,
                .contentType,
                .cookie,
                .location,
                .origin,
                .referer,
                .userAgent,
                //                .init("Pragma")!,
                //                .init("X-Request-With")!,
                //                .init("Sec-Fetch-Dest")!,
                //                .init("Sec-Fetch-Mode")!,
                //                .init("Sec-Fetch-Site")!,
                //                .init("sec-ch-ua")!,
                //                .init("sec-ch-ua-mobile")!,
                //                .init("sec-ch-ua-platform")!,
            ],
            allowMethods: [
                .get,
                .post,
                .head,
                .put,
                .options,
                .delete,
                .patch,
            ],
            allowCredentials: true
        )
        AnalyticsLogMiddleware(
            analytics: modules.analytics,
            resolveAccountID: { request in
                let cookies = request.headers[.cookie]
                    .map { Cookies(from: [$0]) }
                let token =
                    cookies?["session"]?.value
                    ?? request.headers[.authorization]
                    .flatMap { value in
                        let prefix = "Bearer "
                        guard value.hasPrefix(prefix) else { return nil }
                        let token = String(value.dropFirst(prefix.count))
                        return token.isEmpty ? nil : token
                    }
                guard let token, !token.isEmpty else { return nil }
                return try? await modules.auth
                    .makeTokenAuth()
                    .execute(.init(token: token))?
                    .identityId
            }
        )
    }

    router.get("/health") { _, _ in
        Response(status: .ok)
    }

    registerMediaAssetRoutes(on: router, media: modules.media)

    let middlewares: [any ServerMiddleware] = [
        ErrorMiddleware(),
        //        RandomErrorMiddleware(),
        UnescapeHTTPHeadersMiddleware(),
        AuthSubjectMiddleware(auth: modules.auth),
        AuthRenewMiddleware(auth: modules.auth),
    ]

    try SystemBackend.AdminAPIGateway(useCases: modules.system)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try SystemBackend.AppAPIGateway(useCases: modules.system)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    try UserBackend.AppAPIGateway(useCases: modules.user)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try UserBackend.AdminAPIGateway(useCases: modules.user)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    try AccountBackend.AppAPIGateway(useCases: modules.account)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try AccountBackend.AdminAPIGateway(useCases: modules.account)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    try AuthBackend.AppAPIGateway(useCases: modules.auth)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try AuthBackend.AdminAPIGateway(useCases: modules.auth)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    try RedirectBackend.AppAPIGateway(useCases: modules.redirect)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try RedirectBackend.AdminAPIGateway(useCases: modules.redirect)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    try AnalyticsBackend.AppAPIGateway(useCases: modules.analytics)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try AnalyticsBackend.AdminAPIGateway(useCases: modules.analytics)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    try WebBackend.AppAPIGateway(useCases: modules.web)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try WebBackend.AdminAPIGateway(useCases: modules.web)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    try NewsletterBackend.AppAPIGateway(useCases: modules.newsletter)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try NewsletterBackend.AdminAPIGateway(useCases: modules.newsletter)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    try ContactBackend.AppAPIGateway(useCases: modules.contact)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try ContactBackend.AdminAPIGateway(useCases: modules.contact)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    try MediaBackend.AdminAPIGateway(useCases: modules.media)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    try BlogBackend.AppAPIGateway(useCases: modules.blog)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try BlogBackend.AdminAPIGateway(useCases: modules.blog)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    try NewsBackend.AppAPIGateway(useCases: modules.news)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    return router
}
