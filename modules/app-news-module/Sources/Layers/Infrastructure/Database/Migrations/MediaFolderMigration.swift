public import FeatherDBAL
public import FeatherDatabase
public import FeatherDomain
public import FeatherInfrastructure
import FeatherModuleKit
import MediaDomain
import MediaInfrastructure

public struct MediaFolderMigration: DatabaseMigration {
    private let platform: any DatabasePlatform
    public let connection: any DatabaseConnection
    private let idGenerator: any IDGenerator

    public init(
        platform: any DatabasePlatform,
        connection: any DatabaseConnection,
        idGenerator: any IDGenerator
    ) {
        self.platform = platform
        self.connection = connection
        self.idGenerator = idGenerator
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let context = DatabaseTransactionContext(
            platform: platform,
            connection: connection,
            idGenerator: idGenerator
        )
        let folders = MediaAssetNodeFolderDatabaseRepository(context: context)
        try await ensure(
            paths: ["news/articles", "news/categories"],
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
