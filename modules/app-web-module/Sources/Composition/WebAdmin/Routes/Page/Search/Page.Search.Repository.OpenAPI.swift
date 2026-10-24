import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension Page.Search.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        init(api: API.Client) {
            self.api = api
        }

        func searchPages(
            page: Int,
            search: String?
        ) async throws -> Page.Search.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .pageQuery(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                page: .init(size: 20, number: page),
                                filters: .init(search: search)
                            )
                        )
                    )

                switch response {
                case .ok(let okResponse):
                    let body = try okResponse.body.json
                    let items = try await loadItems(
                        body.data.items,
                        using: client
                    )
                    return .init(
                        items: items,
                        total: body.data.total,
                        page: body.query.page.number,
                        pageSize: body.query.page.size
                    )
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }

        private func loadItems(
            _ items: [Components.Schemas.PageQueryItemSchema],
            using client: WebAdminAPI.Client
        ) async throws -> [Page.Search.Item] {
            let metadata = try await loadMetadata(
                using: client,
                referenceIDs: items.map(\.id)
            )
            var metadataByReferenceID:
                [String: Components.Schemas.MetadataResolveItemSchema] = [:]
            for item in metadata {
                precondition(
                    metadataByReferenceID.updateValue(
                        item,
                        forKey: item.referenceId
                    ) == nil
                )
            }

            return items.map { item in
                let metadata = metadataByReferenceID[item.id]
                return .init(
                    id: item.id,
                    title: item.title,
                    metadata: .init(
                        slug: metadata?.slug ?? "",
                        publicationDate: metadata?.publicationDate,
                        expirationDate: metadata?.expirationDate,
                        status: metadata?.status ?? "draft"
                    ),
                    availability: .init(
                        rawValue: metadata?.availability.rawValue ?? "draft"
                    ) ?? .draft
                )
            }
        }

        private func loadMetadata(
            using client: WebAdminAPI.Client,
            referenceIDs: [String]
        ) async throws -> [Components.Schemas.MetadataResolveItemSchema] {
            guard !referenceIDs.isEmpty else { return [] }

            let response = try await client.metadataResolve(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        referenceType: "web.page",
                        referenceIds: referenceIDs
                    )
                )
            )

            switch response {
            case .ok(let okResponse):
                return try okResponse.body.json
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }

    }
}
