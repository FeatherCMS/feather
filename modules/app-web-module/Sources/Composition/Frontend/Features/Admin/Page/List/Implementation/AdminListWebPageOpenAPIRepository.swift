import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI

struct AdminListWebPageOpenAPIRepository:
    AdminListWebPageRepository
{
    let api: WebAdminAPIClient
    private let listUnauthorizedMessage =
        "Please sign in again to view web pages."
    private let listForbiddenMessage =
        "Your account cannot access web pages."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this web page."
    private let deleteForbiddenMessage =
        "Your account cannot delete this web page."
    private let deleteNotFoundMessage =
        "This web page could not be found."

    init(api: WebAdminAPIClient) {
        self.api = api
    }

    func listWebPages(
        page: Int,
        search: String?
    ) async throws -> AdminListWebPageModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .webPageSearch(
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
        _ items: [Components.Schemas.WebPageListItemSchema],
        using client: WebAdminAPI.Client
    ) async throws -> [AdminListWebPageItemModel] {
        let metadata = try await loadMetadata(
            using: client,
            referenceIDs: items.map(\.id)
        )
        let metadataByReferenceID = Dictionary(
            uniqueKeysWithValues: metadata.map {
                ($0.referenceId, $0)
            }
        )

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
    ) async throws -> [Components.Schemas.WebMetadataResolveItemSchema] {
        guard !referenceIDs.isEmpty else { return [] }

        let response = try await client.webMetadataResolve(
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

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.webPageRemove(
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }

}
