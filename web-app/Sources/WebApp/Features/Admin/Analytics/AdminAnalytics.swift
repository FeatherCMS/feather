import Hummingbird

struct AdminAnalytics {
    let renderingEngine: any RenderingEngine

    enum Scope {
        static let logs = PermissionScope(
            module: "analytics",
            resource: "logs"
        )
        static let insights = PermissionScope(
            module: "analytics",
            resource: "insights"
        )
    }

    func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetAnalyticsHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetAnalyticsInsights(
            source: .web,
            renderingEngine: renderingEngine
        )
        .route(on: router)

        AdminGetAnalyticsInsights(
            source: .api,
            renderingEngine: renderingEngine
        )
        .route(on: router)

        AdminListAnalyticsLog(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetAnalyticsLog(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
