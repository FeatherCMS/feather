import FeatherModuleKit
import Foundation
public import WebAdminAPI
import WebApplication
import WebModule

extension AdminAPIGateway {

    public func pageGet(
        _ input: Operations.PageGet.Input
    ) async throws -> Operations.PageGet.Output {
        let useCase = useCases.makeDetailPage()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.pageId)
        )

        return .ok(.init(body: .json(mapPageDetail(result))))
    }

    private func mapPageDetail(
        _ detail: Page.Detail.Output
    ) -> Components.Schemas.PageDetailSchema {
        .init(
            id: detail.id,
            title: detail.title,
            excerpt: detail.excerpt,
            content: detail.content,
            imageAssetId: detail.imageAssetId,
            metadata: mapMetadataSnapshot(detail.metadata),
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }
}
