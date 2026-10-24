public import BlogAppAPI
import BlogApplication
import BlogDomain
import FeatherInfrastructure

extension AppAPIGateway {
    public func blogSettingsGet(
        _ input: Operations.BlogSettingsGet.Input
    ) async throws -> Operations.BlogSettingsGet.Output {
        let settings = try await self.useCases.makeGetPublicSettings()
            .run { context in
                try await context.settings.get()
            }

        return .ok(
            .init(
                body: .json(
                    .init(
                        postListPath: settings.postListPath,
                        authorListPath: settings.authorListPath,
                        tagListPath: settings.tagListPath,
                        postPathPrefix: settings.postPathPrefix,
                        authorPathPrefix: settings.authorPathPrefix,
                        tagPathPrefix: settings.tagPathPrefix,
                        siteNoIndex: false
                    )
                )
            )
        )
    }
}
