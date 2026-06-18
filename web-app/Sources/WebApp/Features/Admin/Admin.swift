import Hummingbird

struct Admin {
    let renderingEngine: any RenderingEngine

    func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAuth(renderingEngine: renderingEngine)
            .route(on: router)
        AdminUser(renderingEngine: renderingEngine)
            .route(on: router)
        AdminSystem(renderingEngine: renderingEngine)
            .route(on: router)
        AdminAnalytics(renderingEngine: renderingEngine)
            .route(on: router)
        AdminRedirect(renderingEngine: renderingEngine)
            .route(on: router)
        AdminBlog(renderingEngine: renderingEngine)
            .route(on: router)
        AdminWeb(renderingEngine: renderingEngine)
            .route(on: router)
        AdminMedia(renderingEngine: renderingEngine)
            .route(on: router)
    }
}
