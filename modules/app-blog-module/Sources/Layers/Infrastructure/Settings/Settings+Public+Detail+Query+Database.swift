public import BlogApplication
public import BlogModule
public import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule

extension BlogModule.Settings.Public.Detail.Query {
    public struct Database: Interface {
        private let variables: SystemModule.Variable.Lookup.Query.Database

        public init(context: any DatabaseContext) {
            variables = SystemModule.Variable.Lookup.Query.Database(
                context: context
            )
        }

        public func get() async throws
            -> BlogModule.Settings.Public.Detail.Output
        {
            let values = try await variables.get(
                keys: [
                    "blog-settings-post-list-path",
                    "blog-settings-author-list-path",
                    "blog-settings-tag-list-path",
                    "blog-settings-post-path-prefix",
                    "blog-settings-author-path-prefix",
                    "blog-settings-tag-path-prefix",
                ]
            )
            return .init(
                postListPath: values["blog-settings-post-list-path"] ?? "blog",
                authorListPath: values["blog-settings-author-list-path"]
                    ?? "authors",
                tagListPath: values["blog-settings-tag-list-path"] ?? "tags",
                postPathPrefix: values["blog-settings-post-path-prefix"]
                    ?? "posts",
                authorPathPrefix: values["blog-settings-author-path-prefix"]
                    ?? "authors",
                tagPathPrefix: values["blog-settings-tag-path-prefix"] ?? "tags"
            )
        }
    }
}
