import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webMenuItemCreate(
        _ input: Operations.WebMenuItemCreate.Input
    ) async throws -> Operations.WebMenuItemCreate.Output {
        let body: Components.Schemas.WebMenuItemCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.web.makeAddMenuItem()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                menuId: input.path.webMenuId,
                label: body.label,
                url: body.url,
                priority: body.priority,
                isBlank: body.isBlank,
                permission: body.permission,
                notes: body.notes ?? ""
            )
        )

        return .created(.init(body: .json(map(result))))
    }
}
