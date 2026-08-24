import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts
import Foundation

extension AdminAPIGateway {

    public func blogAuthorPatch(
        _ input: Operations.BlogAuthorPatch.Input
    ) async throws -> Operations.BlogAuthorPatch.Output {
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
                name: body.name,
                excerpt: body.excerpt,
                content: body.content,
                profileImageAssetId: body.profileImageAssetId,
                metadata: nil
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
