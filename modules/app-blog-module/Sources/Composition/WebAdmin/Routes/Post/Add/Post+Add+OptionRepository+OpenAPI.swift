import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Post.Add.OptionRepository {
    struct OpenAPI: Interface {
        let api: API.Client

        func loadOptions() async throws -> Post.Association.Options {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                async let authors = loadAuthors()
                async let tags = loadTags()
                return try await .init(
                    authors: authors,
                    tags: tags
                )
            }
        }

        private func loadAuthors() async throws
            -> [Post.Association.Option]
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.blogAuthorList(
                    .init(headers: .init(accept: [.init(contentType: .json)]))
                )

                switch response {
                case .ok(let ok):
                    return try ok.body.json.map {
                        .init(id: $0.id, label: $0.name)
                    }
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

        private func loadTags() async throws -> [Post.Association.Option] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.blogTagList(
                    .init(headers: .init(accept: [.init(contentType: .json)]))
                )

                switch response {
                case .ok(let ok):
                    return try ok.body.json.map {
                        .init(id: $0.id, label: $0.title)
                    }
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
}
