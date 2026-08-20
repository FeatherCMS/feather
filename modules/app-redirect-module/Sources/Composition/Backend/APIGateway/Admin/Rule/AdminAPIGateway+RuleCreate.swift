import FeatherApplication
import FeatherContracts
import RedirectAdminAPI
import RedirectApplication
import RedirectDomain
import RedirectContracts

extension AdminAPIGateway {

    /// Create redirect rule
    /*
     curl -i -X 'POST' \
        'http://127.0.0.1:8080/api/v1/admin/redirect/rules' \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{"source":"/old","destination":"/new","statusCode":301,"notes":"legacy"}'
    */
    public func redirectRuleCreate(
        _ input: Operations.RedirectRuleCreate.Input
    ) async throws -> Operations.RedirectRuleCreate.Output {

        let body: Components.Schemas.RedirectRuleCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeAddRule()
        let subject = try await CurrentSubject.require()
        guard let statusCode = StatusCode(rawValue: body.statusCode) else {
            throw Rule.Error.invalidStatusCode
        }
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                source: body.source,
                destination: body.destination,
                statusCode: statusCode,
                notes: body.notes
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
