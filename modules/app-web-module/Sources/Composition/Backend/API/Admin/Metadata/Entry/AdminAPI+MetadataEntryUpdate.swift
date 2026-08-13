import FeatherApplication
import FeatherContracts
import Foundation
import WebAdminAPI
import WebApplication
import WebDomain

extension WebBackend {

    public func webMetadataUpdate(
        _ input: Operations.WebMetadataUpdate.Input
    ) async throws -> Operations.WebMetadataUpdate.Output {
        let body: Components.Schemas.WebMetadataCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = makeEditMetadata()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.webMetadataId,
                template: body.template,
                slug: body.slug,
                publicationDate: body.publicationDate.map(
                    Date.init(timeIntervalSince1970:)
                ),
                expirationDate: body.expirationDate.map(
                    Date.init(timeIntervalSince1970:)
                ),
                status: .init(rawValue: body.status) ?? .draft,
                title: body.title,
                excerpt: body.excerpt,
                imageURL: body.imageUrl,
                canonicalURL: body.canonicalUrl,
                cssCodeInjection: body.cssCodeInjection,
                javascriptCodeInjection: body.javascriptCodeInjection,
                structuredDataCodeInjection: body.structuredDataCodeInjection
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
