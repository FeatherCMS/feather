import FeatherApplication
import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func pageQuery(
        _ input: Operations.PageQuery.Input
    ) async throws -> Operations.PageQuery.Output {
        let query: Components.Schemas.PageQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeSearchPages()
        let objectQuery = map(query)
        let subject = try await CurrentSubject.require()

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
                                size: objectQuery.page.size,
                                number: objectQuery.page.number
                            ),
                            sort: objectQuery.sort.map { sort in
                                let field:
                                    Components.Schemas
                                        .PageQueryItemSearchResponseQuerySchema
                                        .SortPayloadPayload.FieldPayload
                                switch sort.field {
                                case .id: field = .id
                                case .title: field = .title
                                case .createdAt: field = .createdAt
                                case .updatedAt: field = .updatedAt
                                }
                                return .init(
                                    field: field,
                                    direction: sort.direction == .asc
                                        ? .asc : .desc
                                )
                            },
                            filters: .init(search: objectQuery.search)
                        ),
                        data: .init(
                            items: result.items.map(mapQuery),
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}
