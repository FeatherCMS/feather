import FeatherAdmin
import Foundation
import SystemAdminAPI

struct AdminAddSystemVariableDefaultInteractor: AdminAddSystemVariableInteractor
{
    let repository: any AdminAddSystemVariableRepository

    func add(
        input: SystemVariableAddFormInput
    ) async throws {
        do {
            try await repository.create(
                input: .init(
                    key: input.normalizedKey,
                    value: input.normalizedValue,
                    name: input.normalizedName,
                    notes: input.normalizedNotes
                )
            )
        } catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(
        _ error: OpenAPIRepositoryError
    ) -> AdminAddSystemVariableError {
        switch error {
        case .unauthorized:
            .unauthorized
        case .forbidden:
            .forbidden
        case .conflict:
            .conflict
        case .failure, .transport:
            .unavailable
        case .notFound:
            .unavailable
        }
    }
}
