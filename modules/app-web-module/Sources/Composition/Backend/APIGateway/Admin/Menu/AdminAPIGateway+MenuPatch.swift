import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case key
        case name
        case notes
    }

    public func menuPatch(
        _ input: Operations.MenuPatch.Input
    ) async throws -> Operations.MenuPatch.Output {
        let body: Components.Schemas.MenuPatchSchema
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

        let key = try FieldChange(
            value: body.key,
            shouldApply: fields.contains(.key),
            onMissing: { HTTPError(.badRequest) }
        )
        let name = try FieldChange(
            value: body.name,
            shouldApply: fields.contains(.name),
            onMissing: { HTTPError(.badRequest) }
        )
        let notes = OptionalFieldChange(
            value: body.notes,
            shouldApply: fields.contains(.notes)
        )

        let useCase = useCases.makeEditMenu()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.menuId,
                key: key,
                name: name,
                notes: notes
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
