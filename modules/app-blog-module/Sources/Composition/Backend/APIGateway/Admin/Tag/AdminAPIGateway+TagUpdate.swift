public import BlogAdminAPI
import BlogApplication
import FeatherDomain
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogTagPut(
        _ input: Operations.BlogTagPut.Input
    ) async throws -> Operations.BlogTagPut.Output {
        let body: Components.Schemas.BlogTagPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeEditTag()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogTagId,
                title: body.title.map { .set($0) } ?? .unchanged,
                excerpt: body.excerpt.map { .set($0) } ?? .unchanged,
                content: body.content.map { .set($0) } ?? .unchanged,
                imageAssetId: OptionalFieldChange(
                    value: body.imageAssetId ?? nil,
                    shouldApply: body.imageAssetId != nil
                ),
                metadata: nil
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
