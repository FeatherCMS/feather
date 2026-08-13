import FeatherApplication
import FeatherContracts
import SystemAdminAPI
import SystemApplication

extension SystemBackend {

    public func systemVariableDelete(
        _ input: Operations.SystemVariableDelete.Input
    ) async throws -> Operations.SystemVariableDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.makeRemoveVariable()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.systemVariableId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
