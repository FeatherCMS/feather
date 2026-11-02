import AuthAdminAPI
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird
import NIOCore
import NIOFoundationEssentialsCompat
import OpenAPIRuntime
import UserAdminAPI
import UserWebAdmin

public enum AuthLookup {
    public static func url(type: String) -> String {
        var components = URLComponents()
        components.path = WebRoute.root
            .appending(pathComponent: "admin")
            .appending(pathComponent: "auth")
            .appending(pathComponent: "autocomplete").path
        components.queryItems = [URLQueryItem(name: "type", value: type)]
        return components.url?.absoluteString ?? components.path
    }

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
            guard let type = request.queryString("type"),
                ["identity", "email", "credentialEmail"].contains(type)
            else { return Response(status: .badRequest) }

            let authAPI = API.Client(environment: environment, requestContext: context)
            let userAPI = UserWebAdmin.API.Client(environment: environment, requestContext: context)
            let ids = (request.queryString("ids") ?? "")
                .split(separator: ",").map(String.init)
            let items = ids.isEmpty
                ? try await search(request.queryString("q"), type: type, authAPI: authAPI, userAPI: userAPI)
                : try await resolve(ids, type: type, authAPI: authAPI, userAPI: userAPI)
            let data = try JSONEncoder().encode(items)
            return Response(
                status: .ok,
                headers: [.contentType: "application/json; charset=utf-8"],
                body: .init(byteBuffer: ByteBuffer(data: data))
            )
        }

        private func search(
            _ rawQuery: String?,
            type: String,
            authAPI: API.Client,
            userAPI: UserWebAdmin.API.Client
        ) async throws -> [Item] {
            let query = rawQuery?.trimmingCharacters(in: .whitespacesAndNewlines)
            let search = query.flatMap { $0.count >= 2 ? $0 : nil }
            if type == "identity" {
                return try await userAPI.withOpenAPIRepositoryErrorMapping { client in
                    let response = try await client.userIdentityQuery(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(.init(
                            page: .init(size: 20, number: 1),
                            filters: .init(search: search, role: nil)
                        ))
                    )
                    switch response {
                    case UserAdminAPI.Operations.UserIdentityQuery.Output.ok(let value):
                        return try value.body.json.data.items.map {
                            Item(id: String($0.id), label: $0.name)
                        }
                    case UserAdminAPI.Operations.UserIdentityQuery.Output.unauthorized: throw OpenAPIRepositoryError.unauthorized
                    case UserAdminAPI.Operations.UserIdentityQuery.Output.forbidden: throw OpenAPIRepositoryError.forbidden
                    case UserAdminAPI.Operations.UserIdentityQuery.Output.undocumented(statusCode: let code, let response):
                        throw try await userAPI.failure(statusCode: code, responseBody: response.body)
                    }
                }
            }
            return try await authAPI.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.authEmailQuery(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(.init(
                        page: .init(size: 20, number: 1),
                        filters: .init(search: search, identityId: nil)
                    ))
                )
                switch response {
                case .ok(let value):
                    return try value.body.json.data.items.map {
                        Item(id: type == "credentialEmail" ? $0.email : $0.id, label: $0.email)
                    }
                case .unauthorized: throw OpenAPIRepositoryError.unauthorized
                case .forbidden: throw OpenAPIRepositoryError.forbidden
                case .undocumented(let code, let response):
                    throw try await authAPI.failure(statusCode: code, responseBody: response.body)
                }
            }
        }

        private func resolve(
            _ ids: [String],
            type: String,
            authAPI: API.Client,
            userAPI: UserWebAdmin.API.Client
        ) async throws -> [Item] {
            if type == "identity" {
                return try await userAPI.withOpenAPIRepositoryErrorMapping { client in
                    var result: [Item] = []
                    for id in ids {
                        let response = try await client.userIdentityGet(
                            path: .init(userIdentityId: id),
                            headers: .init(accept: [.init(contentType: .json)])
                        )
                        switch response {
                        case UserAdminAPI.Operations.UserIdentityGet.Output.ok(let value): result.append(Item(id: String(try value.body.json.id), label: try value.body.json.name))
                        case UserAdminAPI.Operations.UserIdentityGet.Output.notFound: continue
                        case UserAdminAPI.Operations.UserIdentityGet.Output.unauthorized: throw OpenAPIRepositoryError.unauthorized
                        case UserAdminAPI.Operations.UserIdentityGet.Output.forbidden: throw OpenAPIRepositoryError.forbidden
                        case UserAdminAPI.Operations.UserIdentityGet.Output.undocumented(statusCode: let code, let response):
                            throw try await userAPI.failure(statusCode: code, responseBody: response.body)
                        }
                    }
                    return result
                }
            }
            if type == "email" {
                return try await authAPI.withOpenAPIRepositoryErrorMapping { client in
                    var result: [Item] = []
                    for id in ids {
                        let response = try await client.authEmailGet(
                            path: .init(authEmailId: id),
                            headers: .init(accept: [.init(contentType: .json)])
                        )
                        switch response {
                        case AuthAdminAPI.Operations.AuthEmailGet.Output.ok(let value): result.append(Item(id: try value.body.json.id, label: try value.body.json.email))
                        case AuthAdminAPI.Operations.AuthEmailGet.Output.notFound: continue
                        case AuthAdminAPI.Operations.AuthEmailGet.Output.unauthorized: throw OpenAPIRepositoryError.unauthorized
                        case AuthAdminAPI.Operations.AuthEmailGet.Output.forbidden: throw OpenAPIRepositoryError.forbidden
                        case AuthAdminAPI.Operations.AuthEmailGet.Output.undocumented(statusCode: let code, let response):
                            throw try await authAPI.failure(statusCode: code, responseBody: response.body)
                        }
                    }
                    return result
                }
            }
            return try await search(ids.first, type: type, authAPI: authAPI, userAPI: userAPI)
        }

        private struct Item: Codable, Sendable {
            let id: String
            let label: String
        }
    }
}
