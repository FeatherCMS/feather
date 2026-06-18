import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {

    func systemVariableDelete(
        _ input: Operations.SystemVariableDelete.Input
    ) async throws -> Operations.SystemVariableDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.system.makeRemoveVariable()
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
