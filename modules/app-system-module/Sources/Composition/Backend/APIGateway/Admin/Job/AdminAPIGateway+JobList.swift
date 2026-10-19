import FeatherApplication
import FeatherModuleKit
import Foundation
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {
    public func systemJobList(
        _ input: Operations.SystemJobList.Input
    ) async throws -> Operations.SystemJobList.Output {
        let subject = try await CurrentSubject.require()
        let jobs = try await self.useCases.makeListJobs()
            .execute(
                subject: subject,
                input: .init(
                    page: .init(
                        size: input.query.pageSize ?? 100,
                        number: input.query.pageNumber ?? 1
                    )
                )
            )
        return .ok(.init(body: .json(jobs.items.map(jobDetailSchema(from:)))))
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
