import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird
public import WebAdminAPI
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case label
        case url
        case priority
        case isBlank
        case permission
        case authentication
        case notes
    }

    public func menuItemPatch(
        _ input: Operations.MenuItemPatch.Input
    ) async throws -> Operations.MenuItemPatch.Output {
        let body: Components.Schemas.MenuItemPatchSchema
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

        let label = try FieldChange(
            value: body.label,
            shouldApply: fields.contains(.label),
            onMissing: { HTTPError(.badRequest) }
        )
        let url = try FieldChange(
            value: body.url,
            shouldApply: fields.contains(.url),
            onMissing: { HTTPError(.badRequest) }
        )
        let priority = try FieldChange(
            value: body.priority,
            shouldApply: fields.contains(.priority),
            onMissing: { HTTPError(.badRequest) }
        )
        let isBlank = try FieldChange(
            value: body.isBlank,
            shouldApply: fields.contains(.isBlank),
            onMissing: { HTTPError(.badRequest) }
        )
        let permission = try FieldChange(
            value: body.permission,
            shouldApply: fields.contains(.permission),
            onMissing: { HTTPError(.badRequest) }
        )
        let authentication = try FieldChange(
            value: body.authentication.flatMap(
                MenuItem.Authentication.init(rawValue:)
            ),
            shouldApply: fields.contains(.authentication),
            onMissing: { HTTPError(.badRequest) }
        )
        let notes = OptionalFieldChange(
            value: body.notes,
            shouldApply: fields.contains(.notes)
        )

        let useCase = useCases.makeEditMenuItem()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.menuItemId,
                menuId: input.path.menuId,
                label: label,
                url: url,
                priority: priority,
                isBlank: isBlank,
                permission: permission,
                authentication: authentication,
                notes: notes
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
