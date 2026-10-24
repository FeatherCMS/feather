import AccountModule
public import FeatherWebApp
public import FeatherWebShared
public import Hummingbird

public struct Router {
    private let environment: AppEnvironment
    private let pageRenderer: any PublicPageRenderer

    public init(
        environment: AppEnvironment,
        pageRenderer: any PublicPageRenderer
    ) {
        self.environment = environment
        self.pageRenderer = pageRenderer
    }

    public func route(
        on router: Hummingbird.Router<DefaultRequestContext>
    ) {
        Invitation.Accept
            .Router(
                environment: environment,
                pageRenderer: pageRenderer
            )
            .route(on: router)
    }
}
