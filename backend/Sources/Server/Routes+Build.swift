import Application
import AuthApplication
import Hummingbird
import OpenAPIRuntime
import OpenAPIHummingbird
import Logging
import AppOpenAPI
import AdminOpenAPI

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
        AnalyticsLogMiddleware(modules: modules)
    }

    router.get("/health") { _, _ in
        Response(status: .ok)
    }

    router.get("/test") { _, _ in
        print("-------------------")
        let useCase = modules.auth.makeListMagicLinks()

        do {
            let res = try await useCase.execute(
                subject: .init(id: "foo"),
                input: .init(query: .init())
            )
            print(res)
        }
        catch {
            print(error)
        }
        print("###########################")

        return Response(status: .ok)
    }

    registerMediaAssetRoutes(on: router, modules: modules)

    let middlewares: [any ServerMiddleware] = [
        ErrorMiddleware(),
        //        RandomErrorMiddleware(),
        UnescapeHTTPHeadersMiddleware(),
        AuthSubjectMiddleware(modules: modules),
        AuthRenewMiddleware(modules: modules),
    ]

    let appAPI = AppAPI(modules: modules)
    try appAPI.registerHandlers(on: router, middlewares: middlewares)

    let adminAPI = AdminAPI(modules: modules)
    try adminAPI.registerHandlers(on: router, middlewares: middlewares)

    return router
}
