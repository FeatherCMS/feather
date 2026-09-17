import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaVariantList(_ input: Operations.MediaVariantList.Input) async throws -> Operations.MediaVariantList.Output {
        let query: Components.Schemas.MediaVariantListItemSearchQuerySchema
        switch input.body { case .json(let value): query = value }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeSearchVariants()
        let objectQuery = map(query)
        let list = try await useCase.execute(subject: subject, input: .init(query: objectQuery))
        let total = try await useCase.count(subject: subject, input: .init(query: objectQuery))
        return .ok(.init(body: .json(.init(query: query, data: .init(items: list.items.map(map), total: total)))))
    }
}
