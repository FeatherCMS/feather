import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI

struct AdminViewSystemVariableOpenAPIRepository: AdminViewSystemVariableRepository
{
    let api: SystemAdminAPIClient

    func get(
        id: String
    ) async throws -> SystemVariableDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .systemVariableGet(
                    path: .init(systemVariableId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            switch response {
            case .ok(let okResponse):
                let variable = try okResponse.body.json
                return .init(
                    id: variable.id,
                    key: variable.key,
                    value: variable.value,
                    name: variable.name,
                    notes: variable.notes
                )
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
}
