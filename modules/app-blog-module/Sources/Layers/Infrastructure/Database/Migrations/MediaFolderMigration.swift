import FeatherContracts
public import FeatherDatabase
public import FeatherDomain
public import FeatherInfrastructure
import MediaDomain
import MediaInfrastructure

public struct MediaFolderMigration: DatabaseMigration {
    public let connection: any DatabaseConnection
    private let idGenerator: any IDGenerator

    public init(
        connection: any DatabaseConnection,
        idGenerator: any IDGenerator
    ) {
        self.connection = connection
        self.idGenerator = idGenerator
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let context = DatabaseTransactionContext(
            connection: connection,
            idGenerator: idGenerator
        )
        let folders = MediaAssetNodeFolderDatabaseRepository(context: context)
        try await ensure(
            paths: ["blog/posts", "blog/authors", "blog/tags"],
            using: folders
        )
    }

    private func ensure(
        paths: [String],
        using repository: MediaAssetNodeFolderDatabaseRepository
    ) async throws {
        for path in paths {
            var parentId: String?
            var currentPath = ""
            for component in path.split(separator: "/").map(String.init) {
                currentPath =
                    currentPath.isEmpty
                    ? component
                    : "\(currentPath)/\(component)"
                if let existing = try await repository.find(
                    slugPath: currentPath
                ) {
                    parentId = existing.id
                    continue
                }
                let folder = try await repository.insert(
                    MediaAssetNodeFolder.create(
                        parentId: parentId,
                        name: component,
                        slug: component.slugified,
                        slugPath: currentPath
                    )
                )
                parentId = folder.id
            }
        }
    }
}
