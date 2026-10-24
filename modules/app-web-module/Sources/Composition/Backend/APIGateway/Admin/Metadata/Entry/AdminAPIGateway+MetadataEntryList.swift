import FeatherModuleKit
import Foundation
public import WebAdminAPI
import WebApplication
import WebModule

extension AdminAPIGateway {

    public func metadataList(
        _ input: Operations.MetadataList.Input
    ) async throws -> Operations.MetadataList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListMetadata()
            .execute(subject: subject)
        return .ok(
            .init(
                body: .json(result.items.map(mapMetadataListItem))
            )
        )
    }

    private func mapMetadataListItem(
        _ item: Metadata.List.Output.Item
    ) -> Components.Schemas.MetadataListItemSchema {
        .init(
            id: item.id,
            referenceType: item.referenceType,
            referenceId: item.referenceID,
            slug: item.slug,
            publicationDate: item.publicationDate.timeIntervalSince1970,
            expirationDate: item.expirationDate?.timeIntervalSince1970,
            status: item.status.rawValue,
            availability: .init(rawValue: item.availability(at: .now).rawValue)
                ?? .draft,
            title: item.title,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
