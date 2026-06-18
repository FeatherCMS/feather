import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {

    func systemVariableGet(
        _ input: Operations.SystemVariableGet.Input
    ) async throws -> Operations.SystemVariableGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.system.makeGetVariable()
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
