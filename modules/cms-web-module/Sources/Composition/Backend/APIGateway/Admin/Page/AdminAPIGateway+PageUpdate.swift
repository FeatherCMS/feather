import FeatherDomain
import FeatherModuleKit
import Foundation
import Hummingbird
public import WebAdminAPI
import WebApplication
import WebModule

extension AdminAPIGateway {

    public func pageUpdate(
        _ input: Operations.PageUpdate.Input
    ) async throws -> Operations.PageUpdate.Output {
        let body: Components.Schemas.PagePatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let title = try FieldChange(
            value: body.title,
            shouldApply: true,
            onMissing: { HTTPError(.badRequest) }
        )
        let excerpt = try FieldChange(
            value: body.excerpt,
            shouldApply: true,
            onMissing: { HTTPError(.badRequest) }
        )
        let content = try FieldChange(
            value: body.content,
            shouldApply: true,
            onMissing: { HTTPError(.badRequest) }
        )

        let useCase = useCases.makeEditPage()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.pageId,
                title: title,
                excerpt: excerpt,
                content: content,
                imageAssetId: .init(
                    value: body.imageAssetId,
                    shouldApply: true
                ),
                metadata: nil
            )
        )

        return .ok(.init(body: .json(mapEditedPage(result))))
    }

    func mapEditedPage(
        _ detail: Page.Edit.Output
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
