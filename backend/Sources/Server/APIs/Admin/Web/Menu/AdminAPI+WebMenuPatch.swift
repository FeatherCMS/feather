import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webMenuPatch(
        _ input: Operations.WebMenuPatch.Input
    ) async throws -> Operations.WebMenuPatch.Output {
        let body: Components.Schemas.WebMenuPatchSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.web.makeEditMenu()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.webMenuId,
                key: body.key,
                name: body.name,
                notes: body.notes
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
