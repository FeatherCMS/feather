import AppOpenAPI
import SystemApplication

extension AppAPI {
    func blogRouteSettings(
        _ input: Operations.BlogRouteSettings.Input
    ) async throws -> Operations.BlogRouteSettings.Output {
        let settings = try await modules.system
            .makeGetPublicBlogRouteSettings()
            .execute()

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
                        siteNoIndex: settings.siteNoIndex
                    )
                )
            )
        )
    }
}
