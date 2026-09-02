import FeatherAdmin
import Hummingbird

struct AdminListSystemVariableDefaultInteractor:
    AdminListSystemVariableInteractor
{
    let repository: any AdminListSystemVariableRepository

    func listSystemVariables(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemVariableModel {
        try await repository.listSystemVariables(page: page, search: search)
    }

    func remove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
