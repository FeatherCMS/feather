import FeatherModuleKit
import Foundation
public import WebAdminAPI
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    public func metadataGet(
        _ input: Operations.MetadataGet.Input
    ) async throws -> Operations.MetadataGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeGetMetadata()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.metadataId)
        )

        return .ok(
            .init(
                body: .json(mapMetadataDetail(result))
            )
        )
    }

    func mapMetadataDetail(
        _ detail: Metadata.Detail.Output
    ) -> Components.Schemas.MetadataDetailSchema {
        let availability = Metadata.Model.Availability(
            status: detail.status,
            publicationDate: detail.publicationDate,
            expirationDate: detail.expirationDate,
            at: .now
        )
        return .init(
            id: detail.id,
            referenceType: detail.referenceType,
            referenceId: detail.referenceID,
            slug: detail.slug,
            template: detail.template,
            publicationDate: detail.publicationDate.timeIntervalSince1970,
            expirationDate: detail.expirationDate?.timeIntervalSince1970,
            status: detail.status.rawValue,
            availability: .init(rawValue: availability.rawValue) ?? .draft,
            title: detail.title,
            excerpt: detail.excerpt,
            imageUrl: detail.imageURL,
            canonicalUrl: detail.canonicalURL,
            noIndex: detail.noIndex,
            primaryKeyword: detail.primaryKeyword ?? "",
            cssCodeInjection: detail.cssCodeInjection,
            javascriptCodeInjection: detail.javascriptCodeInjection,
            structuredDataCodeInjection: detail.structuredDataCodeInjection,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func mapMetadataSnapshot(
        _ detail: Metadata.Snapshot
    ) -> Components.Schemas.MetadataDetailSchema {
        .init(
            id: detail.id,
            referenceType: detail.referenceType,
            referenceId: detail.referenceID,
            slug: detail.slug,
            template: detail.template,
            publicationDate: detail.publicationDate.timeIntervalSince1970,
            expirationDate: detail.expirationDate?.timeIntervalSince1970,
            status: detail.status.rawValue,
            availability: .init(
                rawValue: detail.availability(at: .now).rawValue
            ) ?? .draft,
            title: detail.title,
            excerpt: detail.excerpt,
            imageUrl: detail.imageURL,
            canonicalUrl: detail.canonicalURL,
            noIndex: detail.noIndex,
            primaryKeyword: detail.primaryKeyword ?? "",
            cssCodeInjection: detail.cssCodeInjection,
            javascriptCodeInjection: detail.javascriptCodeInjection,
            structuredDataCodeInjection: detail.structuredDataCodeInjection,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }
}
