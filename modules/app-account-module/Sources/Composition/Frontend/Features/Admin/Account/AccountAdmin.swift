public import FeatherAdmin
public import Hummingbird

public struct AccountAdmin {
    private let apiBuilder: AccountAPIBuilder
    public let renderingEngine: any RenderingEngine

    public init(apiBuilder: AccountAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        AdminViewAccountOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAccountProfile(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAccountProfile(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditSettings(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListAccountInvitation(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAccountInvitation(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddAccountInvitation(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAccountInvitation(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveAccountInvitation(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminResendAccountInvitation(apiBuilder: apiBuilder).route(on: router)
    }
}
