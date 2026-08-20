import FeatherApplication
import FeatherContracts
import SystemAdminAPI
import SystemApplication

extension AdminAPIGateway {
    public func systemJobGet(
        _ input: Operations.SystemJobGet.Input
    ) async throws -> Operations.SystemJobGet.Output {
        let subject = try await CurrentSubject.require()
        let job = try await self.useCases.makeGetJob()
            .execute(
                subject: subject,
                input: .init(id: input.path.systemJobId)
            )
        return .ok(.init(body: .json(map(job))))
    }
}
