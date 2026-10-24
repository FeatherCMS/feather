import FeatherModuleKit
import Foundation
public import SystemAdminAPI
import SystemApplication
import SystemModule

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
        return .ok(.init(body: .json(jobDetailSchema(from: job))))
    }

    private func jobDetailSchema(
        from job: Job.Detail.Output
    ) -> Components.Schemas.SystemJobSchema {
        .init(
            id: job.id,
            queueName: job.queueName,
            status: job.status,
            workerId: job.workerId,
            lastModified: job.lastModified.timeIntervalSince1970,
            payload: job.payload
        )
    }
}
