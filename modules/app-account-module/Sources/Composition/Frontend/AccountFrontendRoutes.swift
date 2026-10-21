public import FeatherWebAdmin
import FeatherWebShared
public import Hummingbird

public enum AccountFrontendRoutes {

    public static func registerAppRoutes(
        router: Hummingbird.Router<DefaultRequestContext>,
        renderingEngine: any RenderingEngine,
        apiBuilder: AccountAPIBuilder
    ) {
        AppAcceptAccountInvitation(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .route(on: router)
    }
}
