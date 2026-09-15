import FeatherApplication
import FeatherContracts
import Foundation
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMetadataLookup(
        _ input: Operations.WebMetadataLookup.Input
    ) async throws -> Operations.WebMetadataLookup.Output {
        let query: Components.Schemas.WebMetadataLookupRequestSchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeLookupMetadata()
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
                    items.map {
                        useCases.mapLookupMetadata($0, at: now)
                    }
                )
            )
        )
    }
}
