import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.Folder.Edit.Interactor {
    struct Default: Interface {
        let repository: Asset.Folder.Edit.Repository.OpenAPI

        func load(
            id: String
        ) async throws -> Asset.Folder.Edit.Model {
            let folder = try await repository.getFolder(id: id)
            return .init(
                id: folder.id,
                parentId: folder.parentId,
                name: folder.name,
                slug: folder.slug,
                slugPath: folder.slugPath,
                assetCount: folder.assetCount,
                totalSizeBytes: folder.totalSizeBytes,
                error: nil
            )
        }

        func update(
            id: String,
            input: MediaFolderEditForm
        ) async throws -> Asset.Folder.Edit.Model {
            let folder = try await repository.updateFolder(
                id: id,
                name: input.normalizedName
            )
            return .init(
                id: folder.id,
                parentId: folder.parentId,
                name: folder.name,
                slug: folder.slug,
                slugPath: folder.slugPath,
                assetCount: folder.assetCount,
                totalSizeBytes: folder.totalSizeBytes,
                error: nil
            )
        }
    }
}
