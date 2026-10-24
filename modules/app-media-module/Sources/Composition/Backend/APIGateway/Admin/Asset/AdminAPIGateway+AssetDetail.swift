import FeatherModuleKit
import Foundation
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    public func mediaAssetGet(
        _ input: Operations.MediaAssetGet.Input
    ) async throws -> Operations.MediaAssetGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeDetailAsset()
        do {
            let result = try await useCase.execute(
                subject: subject,
                input: .init(id: input.path.mediaAssetId)
            )
            return .ok(.init(body: .json(mapAssetDetail(result))))
        }
        catch {
            return .notFound(
                .init(
                    body: .json(
                        .init(
                            error: .init(
                                message: "Media asset not found.",
                                reason: "media_asset_not_found"
                            )
                        )
                    )
                )
            )
        }
    }

    private func mapAssetDetail(
        _ detail: Asset.File.Detail.Output
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
