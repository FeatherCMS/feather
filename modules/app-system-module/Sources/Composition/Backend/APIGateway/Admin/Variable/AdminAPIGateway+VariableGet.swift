import FeatherApplication
import FeatherContracts
import SystemAdminAPI
import SystemApplication

extension AdminAPIGateway {

    public func systemVariableGet(
        _ input: Operations.SystemVariableGet.Input
    ) async throws -> Operations.SystemVariableGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeGetVariable()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.systemVariableId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
