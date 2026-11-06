import AnalyticsModule
public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird

public struct Router {
    private let environment: AppEnvironment
    public let renderingEngine: any RenderingEngine

    public init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.environment = environment
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        Overview.View.Router(renderingEngine: renderingEngine)
            .route(on: router)

        Insight.View
            .Router(
                environment: environment,
                source: .web,
                renderingEngine: renderingEngine
            )
            .route(on: router)

        Insight.View
            .Router(
                environment: environment,
                source: .api,
                renderingEngine: renderingEngine
            )
            .route(on: router)

        NotFound.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .route(on: router)

        Log.List
            .Router(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .route(on: router)

        Log.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .route(on: router)
    }
}
