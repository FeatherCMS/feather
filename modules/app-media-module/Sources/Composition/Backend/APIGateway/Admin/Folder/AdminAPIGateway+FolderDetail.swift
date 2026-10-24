import FeatherModuleKit
import Foundation
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaFolderGet(
        _ input: Operations.MediaFolderGet.Input
    ) async throws -> Operations.MediaFolderGet.Output {
        let subject = try await CurrentSubject.require()
        do {
            let result = try await self.useCases.makeDetailFolder()
                .execute(
                    subject: subject,
                    input: .init(id: input.path.mediaFolderId)
                )
            return .ok(.init(body: .json(mapFolderDetail(result))))
        }
        catch {
            return .notFound(
                .init(
                    body: .json(
                        .init(
                            error: .init(
                                message: "Media folder not found.",
                                reason: "media_folder_not_found"
                            )
                        )
                    )
                )
            )
        }
    }

    private func mapFolderDetail(
        _ detail: Asset.Folder.Detail.Output
    ) -> Components.Schemas.MediaFolderDetailSchema {
        .init(
            id: detail.id,
            parentId: detail.parentId,
            name: detail.name,
            slug: detail.slug,
            slugPath: detail.slugPath,
            assetCount: detail.assetCount,
            totalSizeBytes: detail.totalSizeBytes,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }
}
