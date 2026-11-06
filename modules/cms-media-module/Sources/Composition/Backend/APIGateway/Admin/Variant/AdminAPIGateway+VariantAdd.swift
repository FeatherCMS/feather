import FeatherModuleKit
import Foundation
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaVariantPost(_ input: Operations.MediaVariantPost.Input)
        async throws -> Operations.MediaVariantPost.Output
    {
        let body: Components.Schemas.MediaVariantCreateSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeAddVariant()
            .execute(
                subject: subject,
                input: .init(
                    key: body.key,
                    name: body.name,
                    isRequired: body.isRequired,
                    isActive: body.isActive
                )
            )
        return .created(
            .init(
                body: .json(
                    .init(
                        id: result.id,
                        key: result.key,
                        name: result.name,
                        isRequired: result.isRequired,
                        isActive: result.isActive,
                        processors: result.processors.map {
                            .init(
                                id: $0.id,
                                name: $0.name,
                                matchExtensions: $0.matchExtensions,
                                commandTemplate: $0.commandTemplate,
                                isActive: $0.isActive
                            )
                        },
                        createdAt: result.createdAt.timeIntervalSince1970,
                        updatedAt: result.updatedAt.timeIntervalSince1970
                    )
                )
            )
        )
    }
}
