public import FeatherWebShared
public import Hummingbird

public struct Router {
    private let environment: AppEnvironment
    private let renderingEngine: any PublicPageRendering

    public init(
        environment: AppEnvironment,
        renderingEngine: any PublicPageRendering
    ) {
        self.environment = environment
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: Hummingbird.Router<DefaultRequestContext>
    ) {
        AppAcceptAccountInvitation(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .route(on: router)
    }
}
