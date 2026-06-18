import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webMenuItemPatch(
        _ input: Operations.WebMenuItemPatch.Input
    ) async throws -> Operations.WebMenuItemPatch.Output {
        let body: Components.Schemas.WebMenuItemPatchSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.web.makeEditMenuItem()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.webMenuItemId,
                menuId: input.path.webMenuId,
                label: body.label,
                url: body.url,
                priority: body.priority,
                isBlank: body.isBlank,
                permission: body.permission,
                notes: body.notes
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
