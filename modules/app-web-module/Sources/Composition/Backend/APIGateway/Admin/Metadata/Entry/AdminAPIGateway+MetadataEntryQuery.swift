import FeatherApplication
import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func metadataQuery(
        _ input: Operations.MetadataQuery.Input
    ) async throws -> Operations.MetadataQuery.Output {
        let query:
            Components.Schemas.MetadataQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeSearchMetadata()
        let objectQuery = map(query)
        let subject = try await CurrentSubject.require()

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )

        let items = result.items.map(mapQuery)

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: .init(
                            page: .init(
                                size: objectQuery.page.size,
                                number: objectQuery.page.number
                            ),
                            sort: objectQuery.sort.compactMap { sort in
                                let field:
                                    Components.Schemas
                                        .MetadataQueryItemSearchResponseQuerySchema
                                        .SortPayloadPayload.FieldPayload
                                switch sort.field {
                                case .id: field = .id
                                case .slug: field = .slug
                                case .publicationDate: field = .publicationDate
                                case .expirationDate: field = .expirationDate
                                case .status: field = .status
                                case .title: field = .title
                                case .createdAt: field = .createdAt
                                case .updatedAt: field = .updatedAt
                                case .referenceType, .referenceID: return nil
                                }
                                return .init(
                                    field: field,
                                    direction: sort.direction == .asc
                                        ? .asc : .desc
                                )
                            },
                            filters: .init(
                                search: objectQuery.search,
                                referenceType: objectQuery.referenceType
                            )
                        ),
                        data: .init(items: items, total: result.total)
                    )
                )
            )
        )
    }
}
