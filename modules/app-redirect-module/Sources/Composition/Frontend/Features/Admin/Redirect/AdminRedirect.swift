public import FeatherAdmin
public import Hummingbird

public struct AdminRedirect {
    private let apiBuilder: RedirectAPIBuilder
    public let renderingEngine: any RenderingEngine

    public init(apiBuilder: RedirectAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        AdminViewRedirectOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListRedirectRule(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewRedirectRule(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddRedirectRule(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditRedirectRule(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveRedirectRule(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
