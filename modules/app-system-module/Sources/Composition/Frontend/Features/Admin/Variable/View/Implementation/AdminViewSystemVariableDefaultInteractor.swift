import FeatherAdmin
import Foundation

struct AdminViewSystemVariableDefaultInteractor: AdminViewSystemVariableInteractor
{
    let repository: any AdminViewSystemVariableRepository

    func execute(
        entity: AdminViewSystemVariableModel
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
    ) -> AdminViewSystemVariableError {
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
