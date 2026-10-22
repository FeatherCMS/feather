public import BlogAdminAPI
import BlogApplication
import FeatherDomain
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogAuthorPut(
        _ input: Operations.BlogAuthorPut.Input
    ) async throws -> Operations.BlogAuthorPut.Output {
        let body: Components.Schemas.BlogAuthorPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeEditAuthor()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorId,
                name: body.name.map { .set($0) } ?? .unchanged,
                excerpt: body.excerpt.map { .set($0) } ?? .unchanged,
                content: body.content.map { .set($0) } ?? .unchanged,
                profileImageAssetId: OptionalFieldChange(
                    value: body.profileImageAssetId ?? nil,
                    shouldApply: body.profileImageAssetId != nil
                ),
                metadata: nil
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
