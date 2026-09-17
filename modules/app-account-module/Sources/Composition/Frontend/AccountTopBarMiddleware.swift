import AccountAppAPI
import FeatherAdmin
import Foundation
import Hummingbird
import MediaFrontend

public struct AccountTopBarMiddleware: RouterMiddleware {

    private let apiBaseURL: URL

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }

    public func handle(
        _ request: Request,
        context: DefaultRequestContext,
        next: @concurrent (
            Request,
            DefaultRequestContext
        ) async throws -> Response
    ) async throws -> Response {
        var context = context
        guard context.account != nil else {
            return try await next(request, context)
        }

        do {
            let accountAPI = AccountAppAPIClient(
                apiBaseURL: apiBaseURL,
                sessionToken: context.sessionToken
            )
            let profileID = try await accountAPI
                .withOpenAPIRepositoryErrorMapping { client in
                    let response = try await client.accountProfileGet()
                    return try response.ok.body.json.profileImageAssetId
                }
            if let profileID {
                let asset = try await AdminViewMediaAssetOpenAPIRepository(
                    api: .init(
                        apiBaseURL: apiBaseURL,
                        sessionToken: context.sessionToken
                    )
                ).getAssetWithPreview(id: profileID)
                context.accountTopBarState = .init(
                    profileImageURL: asset.previewURL.map(
                        NewAdminMediaAsset.mediaURL(path:)
                    )
                )
            }
        }
        catch {
            context.accountTopBarState = .init()
        }

        return try await next(request, context)
    }
}
