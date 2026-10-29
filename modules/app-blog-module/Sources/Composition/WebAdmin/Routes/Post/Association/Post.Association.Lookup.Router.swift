import BlogAdminAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird
import NIOCore
import NIOFoundationEssentialsCompat
import OpenAPIRuntime

extension Post.Association.Lookup {
    struct Router {
        let path: WebRoute
        let environment: AppEnvironment

        init(environment: AppEnvironment, routes: Post.Router.Routes) {
            self.environment = environment
            self.path = routes.posts.appending(pathComponent: "autocomplete")
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(path.routerPath, use: get)
        }

        private func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            guard let type = request.queryString("type"), ["author", "tag"].contains(type) else {
                return Response(status: .badRequest)
            }
            let api = API.Client(environment: environment, requestContext: context)
            let ids = (request.queryString("ids") ?? "")
                .split(separator: ",").map(String.init)
            let options: [Item]
            if !ids.isEmpty {
                options = try await resolve(ids, type: type, api: api)
            } else {
                let rawQuery = request.queryString("q")?.trimmingCharacters(in: .whitespacesAndNewlines)
                let query = rawQuery.flatMap { $0.count >= 2 ? $0 : nil }
                options = try await search(query, type: type, api: api)
            }
            let data = try JSONEncoder().encode(options)
            return Response(
                status: .ok,
                headers: [.contentType: "application/json; charset=utf-8"],
                body: .init(byteBuffer: ByteBuffer(data: data))
            )
        }

        private func search(_ query: String?, type: String, api: API.Client) async throws -> [Item] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                if type == "author" {
                    let response = try await client.blogAuthorQuery(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(.init(page: .init(size: 20, number: 1), filters: .init(search: query)))
                    )
                    switch response {
                    case .ok(let value):
                        return try value.body.json.data.items.map { Item(id: $0.id, label: $0.name) }
                    case .unauthorized: throw OpenAPIRepositoryError.unauthorized
                    case .forbidden: throw OpenAPIRepositoryError.forbidden
                    case .undocumented(let code, let response):
                        throw try await api.failure(statusCode: code, responseBody: response.body)
                    }
                }
                let response = try await client.blogTagQuery(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(.init(page: .init(size: 20, number: 1), filters: .init(search: query)))
                )
                switch response {
                case .ok(let value):
                    return try value.body.json.data.items.map { Item(id: $0.id, label: $0.title) }
                case .unauthorized: throw OpenAPIRepositoryError.unauthorized
                case .forbidden: throw OpenAPIRepositoryError.forbidden
                case .undocumented(let code, let response):
                    throw try await api.failure(statusCode: code, responseBody: response.body)
                }
            }
        }

        private func resolve(_ ids: [String], type: String, api: API.Client) async throws -> [Item] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                var result: [Item] = []
                for id in ids {
                    if type == "author" {
                        let response = try await client.blogAuthorGet(
                            path: .init(blogAuthorId: id),
                            headers: .init(accept: [.init(contentType: .json)])
                        )
                        switch response {
                        case .ok(let value): result.append(Item(id: try value.body.json.id, label: try value.body.json.name))
                        case .notFound: continue
                        case .unauthorized: throw OpenAPIRepositoryError.unauthorized
                        case .forbidden: throw OpenAPIRepositoryError.forbidden
                        case .undocumented(let code, let response):
                            throw try await api.failure(statusCode: code, responseBody: response.body)
                        }
                    } else {
                        let response = try await client.blogTagGet(
                            path: .init(blogTagId: id),
                            headers: .init(accept: [.init(contentType: .json)])
                        )
                        switch response {
                        case .ok(let value): result.append(Item(id: try value.body.json.id, label: try value.body.json.title))
                        case .notFound: continue
                        case .unauthorized: throw OpenAPIRepositoryError.unauthorized
                        case .forbidden: throw OpenAPIRepositoryError.forbidden
                        case .undocumented(let code, let response):
                            throw try await api.failure(statusCode: code, responseBody: response.body)
                        }
                    }
                }
                return result
            }
        }

        private struct Item: Codable, Sendable {
            let id: String
            let label: String
        }
    }
}

extension Post.Association {
    enum Lookup {
        static func url(type: String) -> String {
            var components = URLComponents()
            components.path = WebRoute.root
                .appending(pathComponent: "admin")
                .appending(pathComponent: "blog")
                .appending(pathComponent: "posts")
                .appending(pathComponent: "autocomplete").path
            components.queryItems = [URLQueryItem(name: "type", value: type)]
            return components.url?.absoluteString ?? components.path
        }
    }
}
