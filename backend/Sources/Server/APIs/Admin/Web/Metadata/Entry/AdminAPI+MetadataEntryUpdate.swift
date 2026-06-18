import AdminOpenAPI
import WebApplication
import WebDomain
import Application
import Foundation

extension AdminAPI {

    func webMetadataUpdate(
        _ input: Operations.WebMetadataUpdate.Input
    ) async throws -> Operations.WebMetadataUpdate.Output {
        let body: Components.Schemas.WebMetadataCreateSchema
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
                referenceType: .some(body.referenceType),
                referenceID: .some(body.referenceId),
                slug: body.slug,
                publicationDate: .some(
                    body.publicationDate.map(Date.init(timeIntervalSince1970:))
                ),
                expirationDate: .some(
                    body.expirationDate.map(Date.init(timeIntervalSince1970:))
                ),
                status: .init(rawValue: body.status) ?? .draft,
                title: body.title,
                excerpt: body.excerpt,
                imageURL: body.imageUrl,
                canonicalURL: body.canonicalUrl ?? "",
                cssCodeInjection: body.cssCodeInjection ?? "",
                javascriptCodeInjection: body.javascriptCodeInjection ?? ""
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
