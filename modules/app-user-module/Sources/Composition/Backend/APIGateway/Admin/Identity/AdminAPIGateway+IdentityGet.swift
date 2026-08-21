import FeatherApplication
import FeatherContracts
import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userIdentityGet(
        _ input: Operations.UserIdentityGet.Input
    ) async throws -> Operations.UserIdentityGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeGetIdentity()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userIdentityId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
