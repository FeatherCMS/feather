import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {

    func systemPermissionGet(
        _ input: Operations.SystemPermissionGet.Input
    ) async throws -> Operations.SystemPermissionGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.system.makeGetPermissions()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.systemPermissionId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
