public import FeatherWebAdmin
import FeatherWebShared
public import Hummingbird

public struct AdminAnalytics {
    private let apiBuilder: AnalyticsAdminAPIBuilder
    public let renderingEngine: any RenderingEngine

    public init(
        apiBuilder: AnalyticsAdminAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        AdminViewAnalyticsOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAnalyticsInsights(
            apiBuilder: apiBuilder,
            source: .web,
            renderingEngine: renderingEngine
        )
        .route(on: router)

        AdminViewAnalyticsInsights(
            apiBuilder: apiBuilder,
            source: .api,
            renderingEngine: renderingEngine
        )
        .route(on: router)

        AdminViewAnalyticsNotFound(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .route(on: router)

        AdminListAnalyticsLog(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAnalyticsLog(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
