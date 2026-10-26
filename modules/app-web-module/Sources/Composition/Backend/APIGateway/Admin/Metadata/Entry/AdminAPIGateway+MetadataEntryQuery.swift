import FeatherApplication
import FeatherModuleKit
import Foundation
public import WebAdminAPI
import WebApplication
import WebDomain
import WebModule

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
        let objectQuery = mapMetadataSearchQuery(query)
        let subject = try await CurrentSubject.require()

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )

        let items = result.items.map(mapMetadataSearchItem)

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

    private func mapMetadataSearchQuery(
        _ query: Components.Schemas.MetadataQueryItemSearchRequestQuerySchema
    ) -> Metadata.Search.Input.Query {
        .init(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            sort: query.sort?.compactMap { sort in
                guard
                    let field = Metadata.Search.Input.Query.Sort.Field(
                        rawValue: sort.field.rawValue
                    )
                else {
                    return nil
                }
                return .init(
                    field: field,
                    direction: sort.direction == .asc ? .asc : .desc
                )
            } ?? [],
            search: query.filters.search,
            referenceType: query.filters.referenceType
        )
    }

    private func mapMetadataSearchItem(
        _ item: Metadata.Search.Output.Item
    ) -> Components.Schemas.MetadataQueryItemSchema {
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
