import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webMenuCreate(
        _ input: Operations.WebMenuCreate.Input
    ) async throws -> Operations.WebMenuCreate.Output {
        let body: Components.Schemas.WebMenuCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.web.makeAddMenu()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                key: body.key,
                name: body.name,
                notes: body.notes ?? ""
            )
        )

        return .created(.init(body: .json(map(result))))
    }
}
