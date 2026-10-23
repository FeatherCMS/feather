import FeatherModuleKit
import Foundation
public import WebAdminAPI
import WebApplication

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
                        mapResolveMetadata($0, at: now)
                    }
                )
            )
        )
    }
}
