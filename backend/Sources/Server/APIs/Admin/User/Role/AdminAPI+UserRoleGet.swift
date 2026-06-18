import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userRoleGet(
        _ input: Operations.UserRoleGet.Input
    ) async throws -> Operations.UserRoleGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeGetRole()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userRoleId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
