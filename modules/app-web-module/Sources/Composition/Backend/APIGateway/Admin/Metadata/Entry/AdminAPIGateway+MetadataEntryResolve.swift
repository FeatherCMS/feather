import FeatherApplication
import FeatherContracts
import Foundation
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMetadataResolve(
        _ input: Operations.WebMetadataResolve.Input
    ) async throws -> Operations.WebMetadataResolve.Output {
        let query: Components.Schemas.WebMetadataResolveRequestSchema
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
                    items.map {
                        useCases.mapResolveMetadata($0, at: now)
                    }
                )
            )
        )
    }
}
