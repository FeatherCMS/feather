import AnalyticsModule
public import FeatherWebAdmin
import FeatherWebShared
public import Hummingbird

public struct Router {
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
        Overview.View.Router(renderingEngine: renderingEngine)
            .route(on: router)

        Insight.View
            .Router(
                apiBuilder: apiBuilder,
                source: .web,
                renderingEngine: renderingEngine
            )
            .route(on: router)

        Insight.View
            .Router(
                apiBuilder: apiBuilder,
                source: .api,
                renderingEngine: renderingEngine
            )
            .route(on: router)

        NotFound.View
            .Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .route(on: router)

        Log.List
            .Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .route(on: router)

        Log.View
            .Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .route(on: router)
    }
}
