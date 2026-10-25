import FeatherModuleKit
import Foundation
public import WebAdminAPI
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    public func pageCreate(
        _ input: Operations.PageCreate.Input
    ) async throws -> Operations.PageCreate.Output {
        let body: Components.Schemas.PageCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeAddPage()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId,
                metadata: defaultPageMetadata(
                    title: body.title,
                    excerpt: body.excerpt
                )
            )
        )

        return .created(.init(body: .json(mapAddedPage(result))))
    }

    private func mapAddedPage(
        _ detail: Page.Add.Output
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

    private func defaultPageMetadata(
        title: String,
        excerpt: String
    ) -> Metadata.Model.Base {
        .init(
            template: "default",
            slug: title.slugified,
            publicationDate: .init(),
            expirationDate: nil,
            status: .draft,
            title: title,
            excerpt: excerpt,
            imageURL: nil,
            canonicalURL: "",
            noIndex: false,
            primaryKeyword: nil,
            cssCodeInjection: "",
            javascriptCodeInjection: "",
            structuredDataCodeInjection: ""
        )
    }
}
