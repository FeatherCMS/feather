import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird
public import RedirectAdminAPI
import RedirectApplication
import RedirectDomain
import RedirectModule

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case source
        case destination
        case statusCode
        case notes
    }

    public func redirectRulePatch(
        _ input: Operations.RedirectRulePatch.Input
    ) async throws -> Operations.RedirectRulePatch.Output {
        let body: Components.Schemas.RedirectRulePatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            throw HTTPError(.badRequest)
        }

        let source = try FieldChange(
            value: body.source,
            shouldApply: fields.contains(.source),
            onMissing: { HTTPError(.badRequest) }
        )
        let destination = try FieldChange(
            value: body.destination,
            shouldApply: fields.contains(.destination),
            onMissing: { HTTPError(.badRequest) }
        )
        let rawStatusCode = try FieldChange(
            value: body.statusCode,
            shouldApply: fields.contains(.statusCode),
            onMissing: { HTTPError(.badRequest) }
        )
        let statusCode: FieldChange<Rule.Model.StatusCode>
        switch rawStatusCode {
        case .unchanged:
            statusCode = .unchanged
        case .set(let value):
            guard let value = Rule.Model.StatusCode(rawValue: value)
            else {
                throw Rule.Model.Error.invalidStatusCode
            }
            statusCode = .set(value)
        }
        let notes = OptionalFieldChange(
            value: body.notes,
            shouldApply: fields.contains(.notes)
        )

        let useCase = self.useCases.makeEditRule()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.redirectRuleId,
                source: source,
                destination: destination,
                statusCode: statusCode,
                notes: notes
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
