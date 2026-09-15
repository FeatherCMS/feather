import FeatherAdmin
import Foundation
import SystemAdminAPI

struct AdminEditSystemVariableDefaultInteractor:
    AdminEditSystemVariableInteractor
{
    let repository: any AdminEditSystemVariableRepository

    func load(
        id: String
    ) async throws -> SystemVariableEditModel {
        do {
            return try await repository.load(id: id)
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    func edit(
        id: String,
        input: SystemVariableEditFormInput
    ) async throws {
        do {
            try await repository.update(
                id: id,
                input: .init(
                    key: input.normalizedKey,
                    value: input.normalizedValue,
                    name: input.normalizedName,
                    notes: input.normalizedNotes
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(
        _ error: OpenAPIRepositoryError
    ) -> AdminEditSystemVariableError {
        switch error {
        case .notFound:
            .notFound
        case .unauthorized:
            .unauthorized
        case .forbidden:
            .forbidden
        case .conflict:
            .conflict
        case .failure(let failure) where failure.statusCode == 409:
            .conflict
        case .failure, .transport:
            .unavailable
        }
    }
}
