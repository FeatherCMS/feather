import BlogDomain
import FeatherDatabase
import FeatherInfrastructure
import SystemDomain
import SystemInfrastructure

public struct SettingsDatabaseRepository: SettingsRepository {
    private let context: any DatabaseContext
    private let variables: any VariableRepository

    public init(context: any DatabaseContext) {
        self.context = context
        self.variables = VariableDatabaseRepository(context: context)
    }

    public func get() async throws -> Settings {
        try await Settings(
            postListPath: variables.find(id: "blog-settings-post-list-path")?
                .value ?? "blog",
            authorListPath: variables.find(
                id: "blog-settings-author-list-path"
            )?
            .value ?? "authors",
            tagListPath: variables.find(id: "blog-settings-tag-list-path")?
                .value ?? "tags",
            postPathPrefix: variables.find(
                id: "blog-settings-post-path-prefix"
            )?
            .value ?? "posts",
            authorPathPrefix: variables.find(
                id: "blog-settings-author-path-prefix"
            )?
            .value ?? "authors",
            tagPathPrefix: variables.find(id: "blog-settings-tag-path-prefix")?
                .value ?? "tags"
        )
    }

    public func update(
        _ model: Settings
    ) async throws -> Settings {
        try await set(
            id: "blog-settings-post-list-path",
            name: "blog.post.list_path",
            value: model.postListPath,
            notes: "Public blog post list path."
        )
        try await set(
            id: "blog-settings-author-list-path",
            name: "blog.author.list_path",
            value: model.authorListPath,
            notes: "Public blog author list path."
        )
        try await set(
            id: "blog-settings-tag-list-path",
            name: "blog.tag.list_path",
            value: model.tagListPath,
            notes: "Public blog tag list path."
        )
        try await set(
            id: "blog-settings-post-path-prefix",
            name: "blog.post.path_prefix",
            value: model.postPathPrefix,
            notes: "Public blog post detail path prefix."
        )
        try await set(
            id: "blog-settings-author-path-prefix",
            name: "blog.author.path_prefix",
            value: model.authorPathPrefix,
            notes: "Public blog author detail path prefix."
        )
        try await set(
            id: "blog-settings-tag-path-prefix",
            name: "blog.tag.path_prefix",
            value: model.tagPathPrefix,
            notes: "Public blog tag detail path prefix."
        )
        return try await get()
    }

    private func set(
        id: String,
        name: String,
        value: String,
        notes: String
    ) async throws {
        if var variable = try await variables.find(id: id) {
            try variable.update(value: value)
            _ = try await variables.update(variable)
        }
        else {
            _ = try await variables.insert(
                Variable.create(id: id, value: value, name: name, notes: notes)
            )
        }
    }
}
