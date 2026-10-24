import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Foundation
import Hummingbird
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    private enum UpdateMaskFields: String, Sendable {
        case name
    }

    public func mediaFolderPatch(
        _ input: Operations.MediaFolderPatch.Input
    ) async throws -> Operations.MediaFolderPatch.Output {
        let body: Components.Schemas.MediaFolderPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            throw HTTPError(.badRequest)
        }
        let name = try FieldChange(
            value: body.name,
            shouldApply: fields.contains(.name),
            onMissing: { HTTPError(.badRequest) }
        )

        let subject = try await CurrentSubject.require()
        do {
            let result = try await self.useCases.makeEditFolder()
                .execute(
                    subject: subject,
                    input: .init(
                        id: input.path.mediaFolderId,
                        name: name
                    )
                )
            return .ok(.init(body: .json(mapEditedFolder(result))))
        }
        catch let error as Asset.Folder.Edit.Error {
            switch error {
            case .notFound:
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
            case .invalidName:
                throw error
            case .duplicatePath:
                throw error
            }
        }
    }

    private func mapEditedFolder(
        _ detail: Asset.Folder.Edit.Output
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
