import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension WebBackend {

    public func webMenuCreate(
        _ input: Operations.WebMenuCreate.Input
    ) async throws -> Operations.WebMenuCreate.Output {
        let body: Components.Schemas.WebMenuCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = makeAddMenu()
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
