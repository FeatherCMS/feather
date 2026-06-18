import AdminOpenAPI
import WebApplication
import WebDomain
import Application
import Foundation

extension AdminAPI {

    func webMetadataPatch(
        _ input: Operations.WebMetadataPatch.Input
    ) async throws -> Operations.WebMetadataPatch.Output {
        let body: Components.Schemas.WebMetadataPatchSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.web.makeEditMetadata()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.webMetadataId,
                slug: body.slug,
                publicationDate: .some(
                    body.publicationDate.map(Date.init(timeIntervalSince1970:))
                ),
                expirationDate: .some(
                    body.expirationDate.map(Date.init(timeIntervalSince1970:))
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
                body: .json(map(result))
            )
        )
    }
}
