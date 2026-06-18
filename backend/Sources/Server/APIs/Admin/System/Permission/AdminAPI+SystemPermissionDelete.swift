import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {

    func systemPermissionDelete(
        _ input: Operations.SystemPermissionDelete.Input
    ) async throws -> Operations.SystemPermissionDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.system.makeRemovePermission()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.systemPermissionId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
