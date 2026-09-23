public import FeatherAdmin
public import Hummingbird

public struct AccountAdmin {
    public let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        AdminViewAccountOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAccountProfile(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAccountProfile(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditSettings(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListAccountInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAccountInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddAccountInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAccountInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveAccountInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminResendAccountInvitation().route(on: router)
    }
}
