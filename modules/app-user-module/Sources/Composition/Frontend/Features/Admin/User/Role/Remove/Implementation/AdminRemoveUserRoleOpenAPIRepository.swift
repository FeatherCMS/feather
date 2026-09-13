import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminRemoveUserRoleOpenAPIRepository: AdminRemoveUserRoleRepository {
    let api: UserAdminAPIClient

    init(api: UserAdminAPIClient) {
        self.api = api
    }

    init() {
        self.api = UserAdminAPIClient(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: nil
        )
    }

    private func name(
        id: String
    ) async throws -> String {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userRoleGet(
                    path: .init(userRoleId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            switch response {
            case .ok(let ok):
                let item = try ok.body.json
                return item.name ?? id
            case .notFound:
                throw OpenAPIRepositoryError.notFound
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

    func names(
        ids: [String]
    ) async throws -> [String] {
        var names: [String] = []
        for id in ids {
            names.append(try await name(id: id))
        }
        return names
    }

    func delete(
        ids: [String]
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userRoleDelete(
                body: .json(.init(ids: ids, results: false, summary: true))
            )
            switch response {
            case .ok: return
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized
            case .forbidden: throw OpenAPIRepositoryError.forbidden
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
