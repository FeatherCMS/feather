import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {
    func systemJobList(
        _ input: Operations.SystemJobList.Input
    ) async throws -> Operations.SystemJobList.Output {
        let subject = try await CurrentSubject.require()
        let jobs = try await modules.system.makeListJobs().execute(subject: subject)
        return .ok(.init(body: .json(jobs.map(map))))
    }
}
