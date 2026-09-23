public import FeatherAdmin
public import Hummingbird

public struct AdminAnalytics {
    public let renderingEngine: any RenderingEngine

    public init(
        renderingEngine: any RenderingEngine
    ) {
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        AdminViewAnalyticsOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAnalyticsInsights(
            source: .web,
            renderingEngine: renderingEngine
        )
        .route(on: router)

        AdminViewAnalyticsInsights(
            source: .api,
            renderingEngine: renderingEngine
        )
        .route(on: router)

        AdminViewAnalyticsNotFound(
            renderingEngine: renderingEngine
        )
        .route(on: router)

        AdminListAnalyticsLog(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAnalyticsLog(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
