import FeatherApplication
import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    public func mediaVariantQuery(_ input: Operations.MediaVariantQuery.Input)
        async throws -> Operations.MediaVariantQuery.Output
    {
        let query:
            Components.Schemas.MediaVariantQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value): query = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeSearchVariants()
        let objectQuery = Variant.Search.Input.Query(
            page: Search.Page(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            search: query.filters.search
        )
        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )
        return .ok(
            .init(
                body: .json(
                    .init(
                        query: .init(
                            page: .init(
                                size: query.page?.size ?? 20,
                                number: query.page?.number ?? 1
                            ),
                            sort: query.sort?
                                .map { rule in
                                    let field:
                                        Components.Schemas
                                            .MediaVariantQueryItemSearchResponseQuerySchema
                                            .SortPayloadPayload.FieldPayload
                                    switch rule.field {
                                    case .id: field = .id
                                    case .key: field = .key
                                    case .name: field = .name
                                    case .isRequired: field = .isRequired
                                    case .isActive: field = .isActive
                                    }
                                    return .init(
                                        field: field,
                                        direction: rule.direction
                                    )
                                },
                            filters: .init(search: query.filters.search)
                        ),
                        data: .init(
                            items: result.items.map {
                                .init(
                                    id: $0.id,
                                    key: $0.key,
                                    name: $0.name,
                                    isRequired: $0.isRequired,
                                    isActive: $0.isActive
                                )
                            },
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}
