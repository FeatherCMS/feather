import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird
import NIOCore
import NIOFoundationEssentialsCompat
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension Settings {
    enum HomePageLookup {
        struct Router {
            let environment: AppEnvironment
            let path: WebRoute

            func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
                router.get(path.routerPath, use: get)
            }

            private func get(
                request: Request,
                context: AuthenticatedRequestContext
            ) async throws -> Response {
                let api = API.Client(environment: environment, requestContext: context)
                let ids = (request.queryString("ids") ?? "").split(separator: ",").map(String.init)
                let items = ids.isEmpty
                    ? try await search(request.queryString("q"), api: api)
                    : try await resolve(ids, api: api)
                let data = try JSONEncoder().encode(items)
                return Response(
                    status: .ok,
                    headers: [.contentType: "application/json; charset=utf-8"],
                    body: .init(byteBuffer: ByteBuffer(data: data))
                )
            }

            private func search(_ query: String?, api: API.Client) async throws -> [Item] {
                try await api.withOpenAPIRepositoryErrorMapping { client in
                    let value = query?.trimmingCharacters(in: .whitespacesAndNewlines)
                    let response = try await client.pageQuery(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(.init(
                            page: .init(size: 20, number: 1),
                            filters: .init(search: value.flatMap { $0.count >= 2 ? $0 : nil })
                        ))
                    )
                    switch response {
                    case .ok(let ok):
                        return try ok.body.json.data.items.map { Item(id: $0.id, label: $0.title) }
                    case .unauthorized: throw OpenAPIRepositoryError.unauthorized
                    case .forbidden: throw OpenAPIRepositoryError.forbidden
                    case .undocumented(let code, let response):
                        throw try await api.failure(statusCode: code, responseBody: response.body)
                    }
                }
            }

            private func resolve(_ ids: [String], api: API.Client) async throws -> [Item] {
                try await api.withOpenAPIRepositoryErrorMapping { client in
                    var result: [Item] = []
                    for id in ids {
                        let response = try await client.pageGet(
                            path: .init(pageId: id),
                            headers: .init(accept: [.init(contentType: .json)])
                        )
                        switch response {
                        case .ok(let value):
                            let page = try value.body.json
                            result.append(Item(id: page.id, label: page.title))
                        case .notFound: continue
                        case .unauthorized: throw OpenAPIRepositoryError.unauthorized
                        case .forbidden: throw OpenAPIRepositoryError.forbidden
                        case .undocumented(let code, let response):
                            throw try await api.failure(statusCode: code, responseBody: response.body)
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
}
