import AccountWebAdmin
import AccountAdminAPI
import FeatherWebShared
import FeatherWebAdmin
import FeatherModuleKit
import Hummingbird
import MediaWebAdmin
import SystemWebAdmin
import SystemModule

struct DefaultAdminPageRenderContextProvider:
    AdminPageRenderContextProvider
{
    let events: any EventPublisher
    let environment: AppEnvironment
    let mediaResolver: MediaResolver

    func make(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> AdminPageRenderContext {
        let menuGroups = try await SystemWebAdmin.Admin.Menu.groups(
            for: context,
            request: request,
            events: events
        )

        var topBarState = AdminTopBar.State()
        do {
            let accountAPI = AccountWebAdmin.API.Client(
                environment: environment,
                requestContext: context
            )
            let profileID =
                try await accountAPI
                .withOpenAPIRepositoryErrorMapping { client in
                    let response = try await client.accountProfileGet(
                        path: .init(userId: context.account.user.id)
                    )
                    return try response.ok.body.json.profileImageAssetId
                }

            if let profileID {
                let asset = try await MediaWebAdmin.API
                    .Client(
                        environment: environment,
                        requestContext: context
                    )
                    .loadImageAsset(assetId: profileID)
                topBarState = .init(
                    profileImageURL: asset?.previewURL
                        .flatMap {
                            mediaResolver.resolve(imagePath: $0)
                        }
                )
            }
        }
        catch {
            topBarState = .init()
        }

        return .init(
            menuGroups: menuGroups,
            accountTopBarState: topBarState
        )
    }
}
