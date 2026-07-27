import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {
    func systemJobGet(
        _ input: Operations.SystemJobGet.Input
    ) async throws -> Operations.SystemJobGet.Output {
        let subject = try await CurrentSubject.require()
        let job = try await modules.system.makeGetJob().execute(
            subject: subject,
            input: .init(id: input.path.systemJobId)
        )
        return .ok(.init(body: .json(map(job))))
    }
}
