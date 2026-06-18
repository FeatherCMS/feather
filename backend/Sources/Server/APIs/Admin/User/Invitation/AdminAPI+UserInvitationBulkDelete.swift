import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userInvitationBulkDelete(
        _ input: Operations.UserInvitationBulkDelete.Input
    ) async throws -> Operations.UserInvitationBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeRemoveInvitation()

        var deletedCount = 0
        var notFoundCount = 0
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    let deleted = try await useCase.execute(
                        subject: subject,
                        input: .init(id: id)
                    )
                    if deleted {
                        deletedCount += 1
                        return .init(id: id, status: .deleted)
                    }
                    notFoundCount += 1
                    return .init(id: id, status: .notFound)
                }

        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: body.ids.count,
                            deleted: deletedCount,
                            notFound: notFoundCount,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }
}
