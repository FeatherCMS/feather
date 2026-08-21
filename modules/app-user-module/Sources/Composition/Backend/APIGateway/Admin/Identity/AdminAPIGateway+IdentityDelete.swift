import FeatherApplication
import FeatherContracts
import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userIdentityDelete(
        _ input: Operations.UserIdentityDelete.Input
    ) async throws -> Operations.UserIdentityDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveIdentity()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userIdentityId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
