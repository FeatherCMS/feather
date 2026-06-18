import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userAccountDelete(
        _ input: Operations.UserAccountDelete.Input
    ) async throws -> Operations.UserAccountDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeRemoveAccount()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userAccountId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
