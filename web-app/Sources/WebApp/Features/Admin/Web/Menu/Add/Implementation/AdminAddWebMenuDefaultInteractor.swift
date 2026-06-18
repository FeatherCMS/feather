import Foundation

struct AdminAddWebMenuDefaultInteractor: AdminAddWebMenuInteractor {
    let repository: any AdminAddWebMenuRepository

    func execute(
        input: WebMenuFormInput
    ) async throws {
        try await repository.create(input: input)
    }
}
