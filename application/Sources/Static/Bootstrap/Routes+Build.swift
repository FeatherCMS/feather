import Configuration
import Foundation
import Hummingbird
import Logging

typealias DefaultRequestContext = BasicRequestContext

func buildRouter() -> Router<DefaultRequestContext> {
    let router = Router(context: DefaultRequestContext.self)

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
