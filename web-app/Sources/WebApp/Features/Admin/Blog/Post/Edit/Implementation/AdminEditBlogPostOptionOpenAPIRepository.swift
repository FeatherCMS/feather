import Foundation
import Hummingbird

struct AdminEditBlogPostOptionOpenAPIRepository:
    AdminEditBlogPostOptionRepository
{
    let api: AdminAPI

    func loadOptions() async throws -> BlogPostAssociationOptionsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            async let authors = loadAuthors()
            async let tags = loadTags()
            return try await .init(
                authors: authors,
                tags: tags
            )
        }
    }

    private func loadAuthors() async throws -> [BlogPostAssociationOptionModel]
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: 500, number: 1),
                        filters: .init(search: nil)
                    )
                )
            )

            switch response {
            case .ok(let ok):
                return try ok.body.json.data.items.map {
                    .init(id: $0.id, label: $0.name)
                }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load blog authors."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot access blog authors."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private func loadTags() async throws -> [BlogPostAssociationOptionModel] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogTagSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: 500, number: 1),
                        filters: .init(search: nil)
                    )
                )
            )

            switch response {
            case .ok(let ok):
                return try ok.body.json.data.items.map {
                    .init(id: $0.id, label: $0.title)
                }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load blog tags."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access blog tags."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
