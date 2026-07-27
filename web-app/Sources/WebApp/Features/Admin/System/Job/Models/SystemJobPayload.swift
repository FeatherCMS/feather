import AdminOpenAPI
import Foundation

struct SystemJobPayload {
    let name: String
    let parameters: [String: String]
    let queuedAt: String?
    let attempt: String?
    let nextScheduledAt: String?
    let traceContext: String?

    init(job: Components.Schemas.SystemJobSchema) {
        guard
            let data = job.payload.data(using: .utf8),
            let root = try? JSONSerialization.jsonObject(with: data)
                as? [String: Any],
            let name = root.keys.first,
            let jobObject = root[name] as? [String: Any],
            let rawParameters = jobObject["p"] as? [String: Any]
        else {
            self.name = "Unknown job"
            self.parameters = [:]
            self.queuedAt = nil
            self.attempt = nil
            self.nextScheduledAt = nil
            self.traceContext = nil
            return
        }
        self.name = name
        self.parameters = rawParameters.reduce(into: [:]) { result, item in
            result[item.key] = Self.stringValue(item.value)
        }
        self.queuedAt = Self.optionalStringValue(jobObject["q"])
        self.attempt = Self.optionalStringValue(jobObject["a"])
        self.nextScheduledAt = Self.optionalStringValue(jobObject["n"])
        self.traceContext = Self.optionalStringValue(jobObject["t"])
    }

    var sender: String? {
        parameters["mailFrom"] ?? parameters["from"]
    }

    var recipient: String? {
        parameters["mailTo"] ?? parameters["to"]
    }

    var subject: String? {
        parameters["subject"]
    }

    var message: String? {
        parameters["messageBody"] ?? parameters["message"]
    }

    var parameterSummary: String {
        parameters.keys.sorted()
            .compactMap { key in
                guard let value = parameters[key] else { return nil }
                return "\(key): \(value)"
            }
            .joined(separator: ", ")
    }

    private static func stringValue(_ value: Any) -> String {
        if let value = value as? [Any] {
            return value.map(stringValue).joined(separator: ", ")
        }
        if let value = value as? NSNull {
            return String(describing: value)
        }
        return String(describing: value)
    }

    private static func optionalStringValue(_ value: Any?) -> String? {
        guard let value, !(value is NSNull) else { return nil }
        return stringValue(value)
    }
}
