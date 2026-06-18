import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userRoleDelete(
        _ input: Operations.UserRoleDelete.Input
    ) async throws -> Operations.UserRoleDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeRemoveRole()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userRoleId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
