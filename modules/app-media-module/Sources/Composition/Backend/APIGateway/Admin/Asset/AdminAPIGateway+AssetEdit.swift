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
        case title
        case altText
    }

    public func mediaAssetPatch(
        _ input: Operations.MediaAssetPatch.Input
    ) async throws -> Operations.MediaAssetPatch.Output {
        let body: Components.Schemas.MediaAssetPatchSchema
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

        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeEditAsset()
            .execute(
                subject: subject,
                input: .init(
                    id: input.path.mediaAssetId,
                    title: OptionalFieldChange(
                        value: body.title,
                        shouldApply: fields.contains(.title)
                    ),
                    altText: OptionalFieldChange(
                        value: body.altText,
                        shouldApply: fields.contains(.altText)
                    )
                )
            )

        return .ok(.init(body: .json(mapEditedAsset(result))))
    }

    private func mapEditedAsset(
        _ detail: Asset.File.Edit.Output
    ) -> Components.Schemas.MediaAssetDetailSchema {
        .init(
            id: detail.id,
            folderId: detail.folderId,
            name: detail.name,
            slug: detail.slug,
            slugPath: detail.slugPath,
            url: mediaResolver.resolve(imagePath: detail.url) ?? detail.url,
            _extension: detail.extension,
            contentType: detail.contentType,
            sizeBytes: detail.sizeBytes,
            status: detail.status,
            title: detail.title,
            altText: detail.altText,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }
}
