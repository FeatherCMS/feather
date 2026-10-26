public import BlogApplication
public import BlogModule
public import FeatherInfrastructure
import SystemDomain
import SystemInfrastructure
import SystemModule

extension BlogModule.Settings.Detail.Query {
    public struct Database: Interface {
        private let variables: any SystemModule.Variable.Repository.Interface

        public init(context: any DatabaseContext) {
            self.variables = SystemModule.Variable.Repository.Database(
                context: context
            )
        }

        public func get() async throws -> BlogModule.Settings.Detail.Output {
            .init(
                postListPath: try await variables.find(
                    key: "blog-settings-post-list-path"
                )?
                .value ?? "blog",
                authorListPath: try await variables.find(
                    key: "blog-settings-author-list-path"
                )?
                .value ?? "authors",
                tagListPath: try await variables.find(
                    key: "blog-settings-tag-list-path"
                )?
                .value ?? "tags",
                postPathPrefix: try await variables.find(
                    key: "blog-settings-post-path-prefix"
                )?
                .value ?? "posts",
                authorPathPrefix: try await variables.find(
                    key: "blog-settings-author-path-prefix"
                )?
                .value ?? "authors",
                tagPathPrefix: try await variables.find(
                    key: "blog-settings-tag-path-prefix"
                )?
                .value ?? "tags"
            )
        }
    }
}
