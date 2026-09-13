import FeatherAdmin
import Foundation

struct AdminGetSystemVariableDefaultInteractor: AdminGetSystemVariableInteractor
{
    let repository: any AdminGetSystemVariableRepository

    func execute(
        entity: AdminGetSystemVariableModel
    ) async throws -> SystemVariableDetailsModel {
        do {
            return try await repository.get(id: entity.id)
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(
        _ error: OpenAPIRepositoryError
    ) -> AdminGetSystemVariableError {
        switch error {
        case .notFound:
            .notFound
        case .unauthorized:
            .unauthorized
        case .forbidden:
            .forbidden
        case .conflict, .failure, .transport:
            .unavailable
        }
    }
}
