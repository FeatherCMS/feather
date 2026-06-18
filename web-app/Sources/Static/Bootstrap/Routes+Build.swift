import Configuration
import Foundation
import Hummingbird

typealias AppRequestContext = BasicRequestContext

func buildRouter() -> Router<AppRequestContext> {
    let router = Router(context: AppRequestContext.self)

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
