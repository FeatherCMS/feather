import FeatherModuleKit
import Foundation
public import WebAdminAPI
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    public func metadataResolve(
        _ input: Operations.MetadataResolve.Input
    ) async throws -> Operations.MetadataResolve.Output {
        let query: Components.Schemas.MetadataResolveRequestSchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeResolveMetadata()
        let subject = try await CurrentSubject.require()
        let items = try await useCase.execute(
            subject: subject,
            input: .init(
                referenceType: query.referenceType,
                referenceIDs: query.referenceIds
            )
        )
        let now = Date()

        return .ok(
            .init(
                body: .json(
                    items.items.map {
                        mapResolvedMetadata($0, at: now)
                    }
                )
            )
        )
    }

    private func mapResolvedMetadata(
        _ item: Metadata.Resolve.Output.Item,
        at date: Date
    ) -> Components.Schemas.MetadataResolveItemSchema {
        .init(
            referenceId: item.referenceID,
            slug: item.slug,
            publicationDate: item.publicationDate.timeIntervalSince1970,
            expirationDate: item.expirationDate?.timeIntervalSince1970,
            status: item.status.rawValue,
            availability: .init(
                rawValue: Metadata.Model.Availability(
                    status: item.status,
                    publicationDate: item.publicationDate,
                    expirationDate: item.expirationDate,
                    at: date
                ).rawValue
            ) ?? .draft
        )
    }
}
