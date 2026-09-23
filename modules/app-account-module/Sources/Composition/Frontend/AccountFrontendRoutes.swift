public import FeatherAdmin
public import Hummingbird

public enum AccountFrontendRoutes {

    public static func registerAppRoutes(
        router: Router<DefaultRequestContext>,
        renderingEngine: any RenderingEngine
    ) {
        AppAcceptAccountInvitation(
            renderingEngine: renderingEngine
        )
        .route(on: router)
    }
}
