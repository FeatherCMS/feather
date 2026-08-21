import FeatherApplication
import FeatherContracts
import SystemAdminAPI
import SystemApplication

extension AdminAPIGateway {
    public func systemJobList(
        _ input: Operations.SystemJobList.Input
    ) async throws -> Operations.SystemJobList.Output {
        let subject = try await CurrentSubject.require()
        let jobs = try await self.useCases.makeListJobs()
            .execute(subject: subject)
        return .ok(.init(body: .json(jobs.map(map))))
    }
}
