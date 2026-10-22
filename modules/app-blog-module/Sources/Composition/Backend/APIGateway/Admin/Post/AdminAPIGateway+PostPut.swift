public import BlogAdminAPI
import BlogApplication
import FeatherDomain
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogPostPut(
        _ input: Operations.BlogPostPut.Input
    ) async throws -> Operations.BlogPostPut.Output {
        let body: Components.Schemas.PostPutSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeEditPost()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogPostId,
                title: body.title.map { .set($0) } ?? .unchanged,
                excerpt: body.excerpt.map { .set($0) } ?? .unchanged,
                content: body.content.map { .set($0) } ?? .unchanged,
                imageAssetId: OptionalFieldChange(
                    value: body.imageAssetId ?? nil,
                    shouldApply: body.imageAssetId != nil
                ),
                authorIds: .set(Array(body.authorIds ?? [])),
                tagIds: .set(Array(body.tagIds ?? [])),
                metadata: nil
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
