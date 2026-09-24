import AccountFrontend
import AccountAppAPI
import FeatherAdmin
import FeatherContracts
import Hummingbird
import MediaFrontend

struct DefaultAdminPageRenderContextProvider:
    AdminPageRenderContextProvider
{
    let events: any EventPublisher
    let accountAPIBuilder: AccountAPIBuilder
    let mediaAPIBuilder: MediaAPIBuilder
    let mediaResolver: MediaResolver

    func make(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> AdminPageRenderContext {
        let menuGroups = try await adminMenuGroups(
            for: context,
            request: request,
            events: events
        )

        var topBarState = NewAdminTopBar.State()
        do {
            let accountAPI = accountAPIBuilder.makeAccountApp(context)
            let profileID =
                try await accountAPI
                .withOpenAPIRepositoryErrorMapping { client in
                    let response = try await client.accountProfileGet()
                    return try response.ok.body.json.profileImageAssetId
                }

            if let profileID {
                let asset =
                    try await mediaAPIBuilder
                    .makeMediaAdmin(context)
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
