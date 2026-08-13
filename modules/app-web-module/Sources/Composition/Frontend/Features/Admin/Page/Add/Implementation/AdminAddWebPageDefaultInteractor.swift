import FeatherAdmin
import Foundation
import OpenAPIRuntime

struct AdminAddWebPageDefaultInteractor: AdminAddWebPageInteractor {
    let repository: any AdminAddWebPageRepository

    func execute(
        input: WebPageFormInput
    ) async throws {
        try await repository.create(input: input)
    }
}
