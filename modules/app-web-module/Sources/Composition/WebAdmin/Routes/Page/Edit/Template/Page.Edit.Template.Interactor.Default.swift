import FeatherModuleKit
import Foundation
import OpenAPIRuntime
import WebModule

extension Page.Edit.Template.Interactor {
    struct Default: Interface {
        let repository: any Page.Edit.Template.Repository.Interface
        let events: any EventPublisher

        func load(
            pageID: String,
            metadataID _: String
        ) async throws -> Page.Edit.Template.Model {
            let content = try await repository.load(pageID: pageID)
            let definition = try await templateDefinition(id: content.templateID)
            let templateData = preparedTemplateData(
                content.templateData,
                fields: definition.fields
            )
            return .init(
                pageID: pageID,
                metadataID: content.metadataID,
                slug: content.slug,
                templateID: content.templateID,
                templateTitle: definition.title,
                fields: definition.fields,
                templateData: templateData,
                error: nil,
                success: nil
            )
        }

        func save(
            pageID: String,
            metadataID _: String,
            input: Page.Edit.Template.Input
        ) async throws -> Page.Edit.Template.Model {
            let content = try await repository.load(pageID: pageID)
            let definition = try await templateDefinition(id: content.templateID)
            let value = try templateValue(
                fields: definition.fields,
                path: "",
                values: input.values
            )
            let data = try JSONEncoder().encode(value)
            let encoded = String(decoding: data, as: UTF8.self)
            try await repository.save(
                metadataID: content.metadataID,
                templateData: encoded
            )
            return .init(
                pageID: pageID,
                metadataID: content.metadataID,
                slug: content.slug,
                templateID: definition.id,
                templateTitle: definition.title,
                fields: definition.fields,
                templateData: encoded,
                error: nil,
                success: "Template values saved."
            )
        }

        private func templateDefinition(
            id: String
        ) async throws -> WebModule.Template.Definition {
            let providers = try await events.trigger(
                event: WebModule.Template.Event.Provider(),
                using: WebModule.Event.Context()
            )
            guard let definition = providers.flatMap(\.templates).first(
                where: { $0.id == id }
            )
            else {
                throw Page.Edit.Template.Error.templateNotFound
            }
            return definition
        }

        private func encodedDefaults(
            for fields: [WebModule.Template.Field]
        ) -> String {
            let defaults = defaultObject(for: fields)
            guard
                let data = try? JSONEncoder().encode(
                    defaults
                )
            else {
                return "{}"
            }
            return String(decoding: data, as: UTF8.self)
        }

        private func preparedTemplateData(
            _ storedTemplateData: String?,
            fields: [WebModule.Template.Field]
        ) -> String {
            let defaults = defaultObject(for: fields)
            guard let storedTemplateData,
                let data = storedTemplateData.data(using: .utf8),
                let storedValue = try? JSONDecoder().decode(
                    WebModule.Template.Value.self,
                    from: data
                ),
                case .object = storedValue
            else {
                return encodedDefaults(for: fields)
            }
            let value = merge(defaults, with: storedValue)
            guard let encoded = try? JSONEncoder().encode(value) else {
                return "{}"
            }
            return String(decoding: encoded, as: UTF8.self)
        }

        private func defaultObject(
            for fields: [WebModule.Template.Field]
        ) -> WebModule.Template.Value {
            var values: [String: WebModule.Template.Value] = [:]
            for field in fields {
                if case .object(let children) = field.kind {
                    values[field.key] = defaultObject(for: children)
                }
                else if let defaultValue = field.defaultValue {
                    values[field.key] = defaultValue
                }
            }
            return .object(values)
        }

        private func merge(
            _ defaultValue: WebModule.Template.Value,
            with storedValue: WebModule.Template.Value
        ) -> WebModule.Template.Value {
            guard case .object(let defaults) = defaultValue,
                case .object(let stored) = storedValue
            else {
                return storedValue
            }
            var merged = defaults
            for (key, value) in stored {
                if let defaultValue = merged[key] {
                    merged[key] = merge(defaultValue, with: value)
                }
                else {
                    merged[key] = value
                }
            }
            return .object(merged)
        }

        private func templateValue(
            fields: [WebModule.Template.Field],
            path: String,
            values: [String: String]
        ) throws -> WebModule.Template.Value {
            var object: [String: WebModule.Template.Value] = [:]
            for field in fields {
                let key = path.isEmpty ? field.key : "\(path).\(field.key)"
                switch field.kind {
                case .object(let children):
                    object[field.key] = try templateValue(
                        fields: children,
                        path: key,
                        values: values
                    )
                case .list(let itemKind):
                    let rawValue = values[key] ?? "[]"
                    guard
                        let data = rawValue.data(using: .utf8),
                        let decoded = try? JSONDecoder().decode(
                            WebModule.Template.Value.self,
                            from: data
                        ),
                        case .array(let items) = decoded
                    else {
                        throw Page.Edit.Template.Error.invalidValue(field.title)
                    }
                    guard !field.required || !items.isEmpty else {
                        throw Page.Edit.Template.Error.requiredValue(
                            field.title
                        )
                    }
                    if case .string = itemKind,
                        items.contains(where: {
                            guard case .string(let item) = $0 else { return false }
                            return item.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ).isEmpty
                        })
                    {
                        throw Page.Edit.Template.Error.requiredValue(field.title)
                    }
                    let converted = try items.map {
                        try convert($0, to: itemKind)
                    }
                    object[field.key] = .array(converted)
                default:
                    let rawValue = values[key] ?? ""
                    object[field.key] = try scalarValue(
                        rawValue,
                        field: field
                    )
                }
            }
            return .object(object)
        }

        private func scalarValue(
            _ value: String,
            field: WebModule.Template.Field
        ) throws -> WebModule.Template.Value {
            if field.required && value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                throw Page.Edit.Template.Error.requiredValue(field.title)
            }
            switch field.kind {
            case .string: return .string(value)
            case .boolean: return .boolean(value == "true" || value == "on")
            case .integer:
                guard let value = Int64(value) else {
                    throw Page.Edit.Template.Error.invalidValue(field.title)
                }
                return .integer(value)
            case .float, .double:
                guard let value = Double(value) else {
                    throw Page.Edit.Template.Error.invalidValue(field.title)
                }
                return .number(value)
            case .date:
                guard Self.isDate(value) else {
                    throw Page.Edit.Template.Error.invalidValue(field.title)
                }
                return .string(value)
            case .object, .list:
                throw Page.Edit.Template.Error.invalidValue(field.title)
            }
        }

        private func convert(
            _ value: WebModule.Template.Value,
            to kind: WebModule.Template.Field.Kind
        ) throws -> WebModule.Template.Value {
            switch (value, kind) {
            case (.string, .string), (.boolean, .boolean), (.integer, .integer), (.number, .float), (.number, .double):
                return value
            case (.integer(let number), .float), (.integer(let number), .double):
                return .number(Double(number))
            case (.array(let values), .list(let itemKind)):
                return .array(try values.map { try convert($0, to: itemKind) })
            case (.object(let object), .object(let fields)):
                var converted: [String: WebModule.Template.Value] = [:]
                for field in fields {
                    guard let item = object[field.key] else {
                        if field.required {
                            throw Page.Edit.Template.Error.requiredValue(field.title)
                        }
                        continue
                    }
                    if field.required,
                        case .string(let string) = item,
                        string.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    {
                        throw Page.Edit.Template.Error.requiredValue(field.title)
                    }
                    if case .list(let itemKind) = field.kind,
                        case .array(let items) = item
                    {
                        guard !field.required || !items.isEmpty else {
                            throw Page.Edit.Template.Error.requiredValue(
                                field.title
                            )
                        }
                        if case .string = itemKind,
                            items.contains(where: {
                                guard case .string(let item) = $0 else { return false }
                                return item.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ).isEmpty
                            })
                        {
                            throw Page.Edit.Template.Error.requiredValue(field.title)
                        }
                    }
                    converted[field.key] = try convert(item, to: field.kind)
                }
                return .object(converted)
            case (.string(let string), .date):
                guard Self.isDate(string) else {
                    throw Page.Edit.Template.Error.invalidValue("Date")
                }
                return value
            default:
                throw Page.Edit.Template.Error.invalidValue("List item")
            }
        }

        private static func isDate(_ value: String) -> Bool {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: value) != nil
        }
    }
}
