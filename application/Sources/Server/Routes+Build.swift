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

    let systemModule = modules.systemApp
    try (systemModule as SystemAppAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try (modules.systemAdmin as SystemAdminAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    let userModule = modules.userApp
    try (userModule as UserAppAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try (modules.userAdmin as UserAdminAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    let accountBackend = modules.accountApp
    try (accountBackend as AccountAppAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try (modules.accountAdmin as AccountAdminAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    let authModule = modules.authApp
    try (authModule as AuthAppAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try (modules.authAdmin as AuthAdminAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    let redirectModule = modules.redirectApp
    try (redirectModule as RedirectAppAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try (modules.redirectAdmin as RedirectAdminAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    let analyticsModule = modules.analyticsApp
    try (analyticsModule as AnalyticsAppAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try (modules.analyticsAdmin as AnalyticsAdminAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    let webModule = modules.webApp
    try (webModule as WebAppAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try (modules.webAdmin as WebAdminAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    let newsletterModule = modules.newsletterApp
    try (newsletterModule as NewsletterAppAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try (modules.newsletterAdmin as NewsletterAdminAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    let contactModule = modules.contactApp
    try (contactModule as ContactAppAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try (modules.contactAdmin as ContactAdminAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    let mediaModule = modules.mediaAdmin
    try (mediaModule as MediaAdminAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    let blogModule = modules.blogApp
    try (blogModule as BlogAppAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )
    try (modules.blogAdmin as BlogAdminAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    let newsModule = modules.newsApp
    try (newsModule as NewsAppAPI.APIProtocol)
        .registerHandlers(
            on: router,
            middlewares: middlewares
        )

    return router
}
