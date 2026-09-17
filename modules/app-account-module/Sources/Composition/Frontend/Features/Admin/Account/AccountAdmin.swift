import AccountAppAPI
import FeatherAdmin
import Foundation
import Hummingbird
import MediaFrontend
import NIOCore

public struct AccountAdmin {
    public let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(AccountAdminRoutes.profileImage.description + "/")
        ) { _, context in
            do {
                let profile =
                    try await AdminViewAccountProfileOpenAPIRepository(
                        api: context.accountAppAPI(),
                        mediaAPI: context.mediaAdminAPI()
                    )
                    .get()
                guard let asset = profile.profileImageAsset else {
                    return Response(
                        status: .ok,
                        headers: [.contentType: "image/svg+xml"],
                        body: .init(
                            byteBuffer: ByteBuffer(string: Self.profileImageFallback)
                        )
                    )
                }
                return Response(
                    status: .seeOther,
                    headers: [
                        .location:
                            NewAdminMediaAsset.mediaURL(
                                path: asset.originalURL
                            )
                    ]
                )
            }
            catch {
                return Response(status: .notFound)
            }
        }

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

    private static let profileImageFallback = """
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#6e6e73" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="7" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/></svg>
        """
}
