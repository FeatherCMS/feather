import FeatherAdmin
import Foundation
import Hummingbird

public struct AdminRedirect {
    public let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        AdminGetRedirectHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListRedirectRule(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetRedirectRule(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddRedirectRule(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditRedirectRule(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveRedirectRule(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
