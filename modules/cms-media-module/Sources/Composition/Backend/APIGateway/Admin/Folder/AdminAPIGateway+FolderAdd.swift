import FeatherModuleKit
import Foundation
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    public func mediaFolderPost(
        _ input: Operations.MediaFolderPost.Input
    ) async throws -> Operations.MediaFolderPost.Output {
        let body: Components.Schemas.MediaFolderCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        do {
            let result = try await self.useCases.makeAddFolder()
                .execute(
                    subject: subject,
                    input: .init(
                        parentId: (body.parentId ?? "").emptyToNil,
                        name: body.name
                    )
                )
            return .created(.init(body: .json(mapAddedFolder(result))))
        }
        catch let error as Asset.Folder.Add.Error {
            switch error {
            case .duplicatePath:
                return .conflict(
                    .init(
                        body: .json(
                            .init(
                                error: .init(
                                    message:
                                        "A media folder with this name already exists.",
                                    reason: "media_folder_conflict"
                                )
                            )
                        )
                    )
                )
            case .invalidName, .parentNotFound:
                throw error
            }
        }
    }

    private func mapAddedFolder(
        _ detail: Asset.Folder.Add.Output
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
