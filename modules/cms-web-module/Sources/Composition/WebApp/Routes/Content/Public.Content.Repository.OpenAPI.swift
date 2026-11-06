import Foundation
import OpenAPIRuntime
import WebAppAPI

extension Public.Content.Repository {
    public struct OpenAPI: Interface {

        private let api: API.Client

        public init(
            api: API.Client
        ) {
            self.api = api
        }

        public func resolveWebRoute(
            slug: String
        ) async throws -> WebAppAPI.Components.Schemas.MetadataSchema? {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                if slug.isEmpty {
                    let response = try await client.metadataRootGet(.init())
                    switch response {
                    case .ok(let value):
                        return try value.body.json
                    case .notFound:
                        return nil
                    case .undocumented(let statusCode, let response):
                        throw try await api.failure(
                            statusCode: statusCode,
                            responseBody: response.body
                        )
                    }
                }
                else {
                    let response = try await client.metadataGet(
                        .init(path: .init(slug: slug))
                    )
                    switch response {
                    case .ok(let value):
                        return try value.body.json
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

        public func publicSiteSettings() async throws
            -> WebAppAPI.Components.Schemas.SiteSettingsSchema
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.siteSettings(.init())
                switch response {
                case .ok(let value):
                    return try value.body.json
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }

        public func publicMetadataSlugs() async throws -> [String] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.metadataList(
                    .init(headers: .init(accept: [.init(contentType: .json)]))
                )
                switch response {
                case .ok(let value):
                    return try value.body.json
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
