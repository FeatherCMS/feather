import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension WebBackend {

    public func webMenuUpdate(
        _ input: Operations.WebMenuUpdate.Input
    ) async throws -> Operations.WebMenuUpdate.Output {
        let body: Components.Schemas.WebMenuCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = makeEditMenu()
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
