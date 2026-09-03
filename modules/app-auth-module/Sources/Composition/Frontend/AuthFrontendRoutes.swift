import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

public enum AuthFrontendRoutes {

    public static func registerAppRoutes(
        router: Router<DefaultRequestContext>,
        renderingEngine: any RenderingEngine,
        authAppClient: AuthAppAPIClient
    ) {
        AppLoginAuth(
            repository: AppLoginAuthOpenAPIRepository(appClient: authAppClient),
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AppLogoutAuth(
            repository: AppLogoutAuthOpenAPIRepository(appClient: authAppClient)
        )
        .controller.route(on: router)

        AppAcceptAccountInvitation(
            renderingEngine: renderingEngine
        )
        .route(on: router)
        AppMagicLink(renderingEngine: renderingEngine).route(on: router)
    }

    public static func registerAdminRoutes(
        router: Router<DefaultRequestContext>,
        renderingEngine: any RenderingEngine
    ) {
        router.get("/admin/auth/profile/image/") { _, context in
            do {
                let profile =
                    try await AdminAuthAccountProfileOpenAPIRepository(
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
        AdminAuth(renderingEngine: renderingEngine).route(on: router)
        AdminListAuthSession(renderingEngine: renderingEngine)
            .controller
            .route(on: router)
        AdminRemoveAuthSession(renderingEngine: renderingEngine)
            .controller
            .route(on: router)
    }
}
