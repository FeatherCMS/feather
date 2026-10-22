import BlogAdminAPI
import BlogApplication
import BlogModule
import WebModule

extension AdminAPIGateway {
    func mapGetSettings(
        _ output: BlogModule.Settings.Detail.Output
    ) -> BlogAdminAPI.Components.Schemas.SettingsGetSchema {
        .init(
            postListPath: output.postListPath,
            authorListPath: output.authorListPath,
            tagListPath: output.tagListPath,
            postPathPrefix: output.postPathPrefix,
            authorPathPrefix: output.authorPathPrefix,
            tagPathPrefix: output.tagPathPrefix
        )
    }

    func mapEditSettings(
        _ output: BlogModule.Settings.Edit.Output
    ) -> BlogAdminAPI.Components.Schemas.SettingsGetSchema {
        .init(
            postListPath: output.postListPath,
            authorListPath: output.authorListPath,
            tagListPath: output.tagListPath,
            postPathPrefix: output.postPathPrefix,
            authorPathPrefix: output.authorPathPrefix,
            tagPathPrefix: output.tagPathPrefix
        )
    }
}
