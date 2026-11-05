public import BlogDomain
public import BlogModule
import FeatherDomain
public import FeatherInfrastructure
import SystemDomain
import SystemInfrastructure
import SystemModule

extension Settings.Repository {
    public struct Database: Interface {
        private let context: any DatabaseContext
        private let variables: any SystemModule.Variable.Repository.Interface

        public init(context: any DatabaseContext) {
            self.context = context
            self.variables = SystemModule.Variable.Repository.Database(
                context: context
            )
        }

        public func get() async throws -> Settings.Model {
            try await Settings.Model(
                postListPath: variables.find(
                    key: "blog-settings-post-list-path"
                )?
                .value ?? "blog",
                authorListPath: variables.find(
                    key: "blog-settings-author-list-path"
                )?
                .value ?? "authors",
                tagListPath: variables.find(key: "blog-settings-tag-list-path")?
                    .value ?? "tags",
                postPathPrefix: variables.find(
                    key: "blog-settings-post-path-prefix"
                )?
                .value ?? "posts",
                authorPathPrefix: variables.find(
                    key: "blog-settings-author-path-prefix"
                )?
                .value ?? "authors",
                tagPathPrefix: variables.find(
                    key: "blog-settings-tag-path-prefix"
                )?
                .value ?? "tags"
            )
        }

        public func update(
            _ model: Settings.Model
        ) async throws -> Settings.Model {
            try await set(
                key: "blog-settings-post-list-path",
                name: "blog.post.list_path",
                value: model.postListPath,
                notes: "Public blog post list path."
            )
            try await set(
                key: "blog-settings-author-list-path",
                name: "blog.author.list_path",
                value: model.authorListPath,
                notes: "Public blog author list path."
            )
            try await set(
                key: "blog-settings-tag-list-path",
                name: "blog.tag.list_path",
                value: model.tagListPath,
                notes: "Public blog tag list path."
            )
            try await set(
                key: "blog-settings-post-path-prefix",
                name: "blog.post.path_prefix",
                value: model.postPathPrefix,
                notes: "Public blog post detail path prefix."
            )
            try await set(
                key: "blog-settings-author-path-prefix",
                name: "blog.author.path_prefix",
                value: model.authorPathPrefix,
                notes: "Public blog author detail path prefix."
            )
            try await set(
                key: "blog-settings-tag-path-prefix",
                name: "blog.tag.path_prefix",
                value: model.tagPathPrefix,
                notes: "Public blog tag detail path prefix."
            )
            return try await get()
        }

        private func set(
            key: String,
            name: String,
            value: String,
            notes: String
        ) async throws {
            if var variable = try await variables.find(key: key) {
                try variable.update(value: .set(value))
                _ = try await variables.update(variable)
            }
            else {
                _ = try await variables.insert(
                    SystemModule.Variable.Model.create(
                        key: key,
                        value: value,
                        name: name,
                        notes: notes
                    )
                )
            }
        }
    }
}
