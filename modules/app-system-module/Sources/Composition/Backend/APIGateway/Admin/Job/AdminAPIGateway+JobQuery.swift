import FeatherApplication
import FeatherModuleKit
import Foundation
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {
    public func systemJobQuery(
        _ input: Operations.SystemJobQuery.Input
    ) async throws -> Operations.SystemJobQuery.Output {
        let query: Components.Schemas.SystemJobSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let page = searchPage(from: query)
        let sort = (query.sort ?? [])
            .map { rule in
                Job.Search.Input.Query.Sort(
                    field: .queuedAt,
                    direction: searchSortDirection(from: rule.direction)
                )
            }
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeSearchJobs()
            .execute(
                subject: subject,
                input: .init(
                    query: .init(
                        page: page,
                        sort: sort,
                        search: query.filters.search,
                        status: query.filters.status
                    )
                )
            )

        let responseSort = query.sort.map {
            $0.map {
                Components.Schemas.SystemJobSearchResponseQuerySchema
                    .SortPayloadPayload(
                        field: .queuedAt,
                        direction: $0.direction
                    )
            }
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
                                status: query.filters.status
                            )
                        ),
                        data: .init(
                            items: result.items.map(jobSearchItemSchema(from:)),
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    private func searchPage(
        from query: Components.Schemas.SystemJobSearchRequestQuerySchema
    ) -> Search.Page {
        let defaults = Search.Page()
        return
            Search.Page(
                size: query.page?.size ?? defaults.size,
                number: query.page?.number ?? defaults.number
            )
            .normalized()
    }

    private func searchSortDirection(
        from direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }

    private func jobSearchItemSchema(
        from job: Job.Detail.Output
    ) -> Components.Schemas.SystemJobSchema {
        .init(
            id: job.id,
            queueName: job.queueName,
            status: job.status,
            workerId: job.workerId,
            lastModified: job.lastModified.timeIntervalSince1970,
            payload: job.payload
        )
    }
}
