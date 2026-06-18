import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userAccountGet(
        _ input: Operations.UserAccountGet.Input
    ) async throws -> Operations.UserAccountGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeGetAccount()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userAccountId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
