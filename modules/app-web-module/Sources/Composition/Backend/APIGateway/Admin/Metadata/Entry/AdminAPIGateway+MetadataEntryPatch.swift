import FeatherApplication
import FeatherContracts
import Foundation
import WebAdminAPI
import WebApplication
import WebDomain

extension AdminAPIGateway {

    public func webMetadataPatch(
        _ input: Operations.WebMetadataPatch.Input
    ) async throws -> Operations.WebMetadataPatch.Output {
        let body: Components.Schemas.WebMetadataPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeEditMetadata()
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
                status: body.status.flatMap { .init(rawValue: $0) },
                title: body.title,
                excerpt: body.excerpt,
                imageURL: body.imageUrl,
                canonicalURL: body.canonicalUrl,
                noIndex: body.noIndex,
                primaryKeyword: body.primaryKeyword,
                cssCodeInjection: body.cssCodeInjection,
                javascriptCodeInjection: body.javascriptCodeInjection,
                structuredDataCodeInjection: body.structuredDataCodeInjection
            )
        )

        return .ok(
            .init(
                body: .json(useCases.map(result))
            )
        )
    }
}
