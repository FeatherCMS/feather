import FeatherApplication
import FeatherContracts
import UserAdminAPI
import UserApplication

extension UserBackend {

    public func userRoleGet(
        _ input: Operations.UserRoleGet.Input
    ) async throws -> Operations.UserRoleGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = makeGetRole()
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
