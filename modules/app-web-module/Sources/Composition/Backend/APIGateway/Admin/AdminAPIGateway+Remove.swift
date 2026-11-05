import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {
    public func menuRemove(_ input: Operations.MenuRemove.Input)
        async throws -> Operations.MenuRemove.Output
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

    public func menuItemRemove(
        _ input: Operations.MenuItemRemove.Input
    ) async throws -> Operations.MenuItemRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveMenuItem()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids, menuId: input.path.menuId)
        )
        return .noContent(.init())
    }

    public func pageRemove(_ input: Operations.PageRemove.Input)
        async throws -> Operations.PageRemove.Output
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
