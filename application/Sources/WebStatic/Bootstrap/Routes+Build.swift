import Hummingbird
import FeatherWebShared
import Logging

func buildRouter() -> Router<BasicRequestContext> {
    let router = Router(context: BasicRequestContext.self)

    router.addMiddleware {
        LogRequestsMiddleware(.info)
        FileMiddleware(
            cacheControl: .init([
                (.textCss, [.maxAge(60 * 60 * 24 * 30)]),
                (.imageJpeg, [.maxAge(60 * 60 * 24 * 30)]),
                (.imagePng, [.maxAge(60 * 60 * 24 * 30)]),
            ])
        )
    }

    router.get("/health") { _, _ in
        Response(status: .ok)
    }

    return router
}
