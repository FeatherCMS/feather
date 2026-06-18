import AppOpenAPI
import Hummingbird

struct AppPublicContentOpenAPIRepository: AppPublicContentRepository {
    let api: ApplicationAPI

    func getSiteSettings() async throws
        -> Components.Schemas.WebSiteSettingsSchema
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webSiteSettings(.init())
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func listMenus() async throws -> Components.Schemas.WebMenuListSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMenuList(.init())
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func getRouteSettings() async throws
        -> Components.Schemas.BlogRouteSettingsSchema
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogRouteSettings(.init())
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func listBlogPosts() async throws -> Components.Schemas.BlogPostListSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogPostList(.init())
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func resolveWebRoute(
        slug: String
    ) async throws -> Components.Schemas.WebMetadataSchema? {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMetadataGet(
                .init(path: .init(slug: slug))
            )
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound:
                return nil
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func getBlogPost(
        id: String
    ) async throws -> Components.Schemas.BlogPostDetailSchema? {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogPostGet(
                .init(path: .init(id: id))
            )
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound:
                return nil
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func listBlogAuthors() async throws
        -> Components.Schemas.BlogAuthorListSchema
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorList(.init())
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func getBlogAuthor(
        id: String
    ) async throws -> Components.Schemas.BlogAuthorDetailSchema? {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorGet(
                .init(path: .init(id: id))
            )
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound:
                return nil
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func listBlogTags() async throws -> Components.Schemas.BlogTagListSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogTagList(.init())
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func getBlogTag(
        id: String
    ) async throws -> Components.Schemas.BlogTagDetailSchema? {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogTagGet(
                .init(path: .init(id: id))
            )
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound:
                return nil
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func getWebPage(
        id: String
    ) async throws -> Components.Schemas.WebPageDetailSchema? {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webPageGet(
                .init(path: .init(id: id))
            )
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound:
                return nil
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
