public import ContactAdminAPI
import ContactApplication
import ContactDomain
import ContactModule
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {
    public func contactSubmissionQuery(
        _ input: Operations.ContactSubmissionQuery.Input
    ) async throws -> Operations.ContactSubmissionQuery.Output {
        let query:
            Components.Schemas
                .ContactSubmissionQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let defaults = Search.Page()
        let page =
            Search.Page(
                size: query.page?.size ?? defaults.size,
                number: query.page?.number ?? defaults.number
            )
            .normalized()
        let sort = (query.sort ?? [])
            .map { rule in
                Submission.Search.Input.Query.Sort(
                    field: searchSortField(from: rule.field),
                    direction: rule.direction == .asc ? .asc : .desc
                )
            }
        let result = try await useCases.makeSearchContactSubmissions()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(
                    query: .init(
                        page: page,
                        sort: sort,
                        search: query.filters.search,
                        formKey: query.filters.formKey
                    )
                )
            )

        let responseSort = query.sort?
            .map { rule in
                Components.Schemas
                    .ContactSubmissionQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(
                        field: responseSortField(from: rule.field),
                        direction: rule.direction
                    )
            }

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: .init(
                            page: .init(size: page.size, number: page.number),
                            sort: responseSort,
                            filters: .init(
                                search: query.filters.search,
                                formKey: query.filters.formKey
                            )
                        ),
                        data: .init(
                            items: result.items.map {
                                .init(
                                    id: $0.id,
                                    formKey: $0.formKey,
                                    formName: $0.formName,
                                    status: $0.status.rawValue,
                                    createdAt: $0.createdAt
                                        .timeIntervalSince1970,
                                    email: $0.email
                                )
                            },
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    private func searchSortField(
        from field: Components.Schemas
            .ContactSubmissionQueryItemSearchRequestQuerySchema
            .SortPayloadPayload.FieldPayload
    ) -> Submission.Search.Input.Query.Sort.Field {
        switch field {
        case .createdAt: .createdAt
        case .formName: .formName
        case .status: .status
        }
    }

    private func responseSortField(
        from field: Components.Schemas
            .ContactSubmissionQueryItemSearchRequestQuerySchema
            .SortPayloadPayload.FieldPayload
    )
        -> Components.Schemas
        .ContactSubmissionQueryItemSearchResponseQuerySchema
        .SortPayloadPayload.FieldPayload
    {
        switch field {
        case .createdAt: .createdAt
        case .formName: .formName
        case .status: .status
        }
    }
}
