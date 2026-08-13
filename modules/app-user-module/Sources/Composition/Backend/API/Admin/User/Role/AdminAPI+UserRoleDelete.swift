import FeatherApplication
import FeatherContracts
import UserAdminAPI
import UserApplication

extension UserBackend {

    public func userRoleDelete(
        _ input: Operations.UserRoleDelete.Input
    ) async throws -> Operations.UserRoleDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = makeRemoveRole()
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
