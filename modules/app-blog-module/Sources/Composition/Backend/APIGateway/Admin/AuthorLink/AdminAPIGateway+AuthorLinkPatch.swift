public import BlogAdminAPI
import BlogApplication
import FeatherBackend
import FeatherDomain
import FeatherModuleKit

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case label
        case url
        case priority
        case isBlank
        case permission
        case notes
    }

    public func blogAuthorLinkPatch(
        _ input: Operations.BlogAuthorLinkPatch.Input
    ) async throws -> Operations.BlogAuthorLinkPatch.Output {
        let body: Components.Schemas.AuthorLinkPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(reason: "Invalid updateMask")
                    )
                )
            )
        }

        guard
            let label = requiredFieldChange(
                value: body.label,
                shouldApply: fields.contains(.label)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: label"
                        )
                    )
                )
            )
        }
        guard
            let url = requiredFieldChange(
                value: body.url,
                shouldApply: fields.contains(.url)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: url"
                        )
                    )
                )
            )
        }
        guard
            let priority = requiredFieldChange(
                value: body.priority,
                shouldApply: fields.contains(.priority)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: priority"
                        )
                    )
                )
            )
        }
        guard
            let isBlank = requiredFieldChange(
                value: body.isBlank,
                shouldApply: fields.contains(.isBlank)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: isBlank"
                        )
                    )
                )
            )
        }
        guard
            let permission = requiredFieldChange(
                value: body.permission,
                shouldApply: fields.contains(.permission)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: permission"
                        )
                    )
                )
            )
        }
        guard
            let notes = requiredFieldChange(
                value: body.notes,
                shouldApply: fields.contains(.notes)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: notes"
                        )
                    )
                )
            )
        }

        let useCase = self.useCases.makeEditAuthorLink()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorLinkId,
                authorId: input.path.blogAuthorId,
                label: label,
                url: url,
                priority: priority,
                isBlank: isBlank,
                permission: permission,
                notes: notes
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
