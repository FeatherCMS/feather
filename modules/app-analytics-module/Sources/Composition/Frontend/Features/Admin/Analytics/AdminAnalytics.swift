import FeatherAdmin
import Hummingbird

public struct AdminAnalytics {
    public let renderingEngine: any RenderingEngine

    public init(
        renderingEngine: any RenderingEngine
    ) {
        self.renderingEngine = renderingEngine
    }

    public enum Scope {
        public static let logs = PermissionScope(
            module: "analytics",
            resource: "logs"
        )
        public static let insights = PermissionScope(
            module: "analytics",
            resource: "insights"
        )
        public static let notFound = PermissionScope(
            module: "analytics",
            resource: "not-found"
        )
    }

    public func route(
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

        AdminGetAnalyticsNotFound(
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
