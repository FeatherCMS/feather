import FeatherModuleKit
import Foundation
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaFolderList(
        _ input: Operations.MediaFolderList.Input
    ) async throws -> Operations.MediaFolderList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListFolders()
            .execute(
                subject: subject,
                input: .init(parentId: input.query.parentId)
            )
        return .ok(
            .init(body: .json(result.items.map(mapFolderListItem)))
        )
    }

    private func mapFolderListItem(
        _ item: Asset.Folder.List.Output.Item
    ) -> Components.Schemas.MediaFolderListItemSchema {
        .init(
            id: item.id,
            parentId: item.parentId,
            name: item.name,
            slug: item.slug,
            slugPath: item.slugPath,
            assetCount: item.assetCount,
            totalSizeBytes: item.totalSizeBytes,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
