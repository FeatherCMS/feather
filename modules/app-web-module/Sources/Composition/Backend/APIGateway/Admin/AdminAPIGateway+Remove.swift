import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {
    public func webMenuRemove(_ input: Operations.WebMenuRemove.Input)
        async throws -> Operations.WebMenuRemove.Output
    {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveMenu()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }

    public func webMenuItemRemove(
        _ input: Operations.WebMenuItemRemove.Input
    ) async throws -> Operations.WebMenuItemRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveMenuItem()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids, menuId: input.path.webMenuId)
        )
        return .noContent(.init())
    }

    public func webPageRemove(_ input: Operations.WebPageRemove.Input)
        async throws -> Operations.WebPageRemove.Output
    {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemovePage()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
