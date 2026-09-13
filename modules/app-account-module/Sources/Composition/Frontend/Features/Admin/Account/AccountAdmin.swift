import AccountAppAPI
import FeatherAdmin
import Foundation
import Hummingbird
import MediaFrontend

public struct AccountAdmin {
    public let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(RouterPath(AccountAdminRoutes.profileImage.description + "/")) { _, context in
            do {
                let profile = try await AdminGetAccountProfileOpenAPIRepository(
                    api: context.accountAppAPI(),
                    mediaAPI: context.mediaAdminAPI()
                )
                .get()
                guard let asset = profile.profileImageAsset else {
                    return Response(status: .notFound)
                }
                let prefix = "media/assets/"
                let storageKey =
                    asset.storageKey.hasPrefix(prefix)
                    ? String(asset.storageKey.dropFirst(prefix.count))
                    : asset.storageKey
                let encodedStorageKey =
                    storageKey.addingPercentEncoding(
                        withAllowedCharacters: .urlPathAllowed
                    ) ?? storageKey
                return Response(
                    status: .seeOther,
                    headers: [
                        .location:
                            "\(AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString)/media/assets/\(encodedStorageKey)"
                    ]
                )
            }
            catch {
                return Response(status: .notFound)
            }
        }

        AdminGetAccountOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetAccountProfile(
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

        AdminGetAccountInvitation(
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
