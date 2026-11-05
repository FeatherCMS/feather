import Foundation
import NewsletterModule

extension Campaign.Subscriber.Import {
    enum CSVParser {
        struct Record: Sendable {
            let line: Int
            let email: String
            let firstName: String
            let lastName: String
            let status: String?
        }

        enum ParseError: Error, CustomStringConvertible, Equatable {
            case fileTooLarge
            case tooManyRecords
            case malformed(line: Int)
            case invalidUTF8(line: Int)
            case missingEmailColumn
            case wrongColumnCount(line: Int)
            case missingEmail(line: Int)
            case invalidStatus(line: Int)

            var description: String {
                switch self {
                case .fileTooLarge:
                    return "CSV file must be 5 MB or smaller."
                case .tooManyRecords:
                    return "CSV file can contain at most 5,000 data rows."
                case .malformed(let line):
                    return "CSV syntax is invalid near line \(line)."
                case .invalidUTF8(let line):
                    return "CSV contains invalid UTF-8 text near line \(line)."
                case .missingEmailColumn:
                    return "CSV must contain an email column in its first row."
                case .wrongColumnCount(let line):
                    return
                        "CSV row \(line) has a different number of columns than the header."
                case .missingEmail(let line):
                    return "CSV row \(line) has no email address."
                case .invalidStatus(let line):
                    return
                        "CSV row \(line) has an invalid status. Use subscribed or unsubscribed."
                }
            }
        }

        private enum State: Equatable {
            case fieldStart
            case unquoted
            case quoted
            case afterQuote
        }

        static func parse(_ source: String) throws -> [Record] {
            guard source.utf8.count <= 5_000_000 else {
                throw ParseError.fileTooLarge
            }

            let rows = try parseRows(Array(source.utf8))
            guard let header = rows.first else {
                throw ParseError.missingEmailColumn
            }

            let headers = try header.fields.enumerated()
                .map { index, bytes in
                    guard let value = String(bytes: bytes, encoding: .utf8)
                    else {
                        throw ParseError.invalidUTF8(line: header.line)
                    }
                    let normalized =
                        value
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .replacingOccurrences(of: "\u{FEFF}", with: "")
                        .lowercased()
                        .replacingOccurrences(of: "-", with: "_")
                    return (index, normalized)
                }
            guard let emailIndex = headers.first(where: { $0.1 == "email" })?.0
            else {
                throw ParseError.missingEmailColumn
            }
            let firstNameIndex = headers.first {
                ["first_name", "firstname"].contains($0.1)
            }?
            .0
            let lastNameIndex = headers.first {
                ["last_name", "lastname"].contains($0.1)
            }?
            .0
            let statusIndex = headers.first { $0.1 == "status" }?.0

            var records: [Record] = []
            for row in rows.dropFirst() {
                if row.fields.allSatisfy({ field in
                    field.allSatisfy { $0 == 32 || $0 == 9 }
                }) {
                    continue
                }
                guard row.fields.count == headers.count else {
                    throw ParseError.wrongColumnCount(line: row.line)
                }

                let values = try row.fields.map { bytes in
                    guard let value = String(bytes: bytes, encoding: .utf8)
                    else {
                        throw ParseError.invalidUTF8(line: row.line)
                    }
                    return value.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                let email = values[emailIndex]
                let emailParts = email.split(
                    separator: "@",
                    omittingEmptySubsequences: false
                )
                guard
                    emailParts.count == 2,
                    !emailParts[0].isEmpty,
                    !emailParts[1].isEmpty,
                    !email.contains(where: \.isWhitespace)
                else {
                    throw ParseError.missingEmail(line: row.line)
                }
                let statusValue = statusIndex.map { values[$0].lowercased() }
                let status = statusValue?.isEmpty == true ? nil : statusValue
                if let status, !["subscribed", "unsubscribed"].contains(status)
                {
                    throw ParseError.invalidStatus(line: row.line)
                }
                records.append(
                    .init(
                        line: row.line,
                        email: email,
                        firstName: firstNameIndex.map { values[$0] } ?? "",
                        lastName: lastNameIndex.map { values[$0] } ?? "",
                        status: status
                    )
                )
                guard records.count <= 5_000 else {
                    throw ParseError.tooManyRecords
                }
            }
            return records
        }

        private struct Row {
            let line: Int
            let fields: [[UInt8]]
        }

        private static func parseRows(_ bytes: [UInt8]) throws -> [Row] {
            var rows: [Row] = []
            var fields: [[UInt8]] = []
            var field: [UInt8] = []
            var state = State.fieldStart
            var line = 1
            var rowLine = 1
            var quotedFieldLine = 1
            var index = 0

            func appendRow() throws {
                guard rows.count < 5_001 else {
                    throw ParseError.tooManyRecords
                }
                fields.append(field)
                rows.append(.init(line: rowLine, fields: fields))
                fields = []
                field = []
                rowLine = line + 1
            }

            while index < bytes.count {
                let byte = bytes[index]
                switch state {
                case .fieldStart:
                    if byte == 34 {
                        quotedFieldLine = line
                        state = .quoted
                    }
                    else if byte == 44 {
                        fields.append([])
                    }
                    else if byte == 10 || byte == 13 {
                        if byte == 13, index + 1 < bytes.count,
                            bytes[index + 1] == 10
                        {
                            index += 1
                        }
                        try appendRow()
                        line += 1
                        rowLine = line
                    }
                    else {
                        field.append(byte)
                        state = .unquoted
                    }
                case .unquoted:
                    if byte == 44 {
                        fields.append(field)
                        field = []
                        state = .fieldStart
                    }
                    else if byte == 10 || byte == 13 {
                        if byte == 13, index + 1 < bytes.count,
                            bytes[index + 1] == 10
                        {
                            index += 1
                        }
                        try appendRow()
                        line += 1
                        rowLine = line
                        state = .fieldStart
                    }
                    else if byte == 34 {
                        throw ParseError.malformed(line: line)
                    }
                    else {
                        field.append(byte)
                    }
                case .quoted:
                    if byte == 34 {
                        if index + 1 < bytes.count, bytes[index + 1] == 34 {
                            field.append(34)
                            index += 1
                        }
                        else {
                            state = .afterQuote
                        }
                    }
                    else {
                        field.append(byte)
                        if byte == 10 {
                            line += 1
                        }
                        else if byte == 13 {
                            if index + 1 < bytes.count, bytes[index + 1] == 10 {
                                field.append(10)
                                index += 1
                            }
                            line += 1
                        }
                    }
                case .afterQuote:
                    if byte == 44 {
                        fields.append(field)
                        field = []
                        state = .fieldStart
                    }
                    else if byte == 10 || byte == 13 {
                        if byte == 13, index + 1 < bytes.count,
                            bytes[index + 1] == 10
                        {
                            index += 1
                        }
                        try appendRow()
                        line += 1
                        rowLine = line
                        state = .fieldStart
                    }
                    else {
                        throw ParseError.malformed(line: line)
                    }
                }
                index += 1
            }

            if case .quoted = state {
                throw ParseError.malformed(line: quotedFieldLine)
            }
            if !field.isEmpty || !fields.isEmpty || state == .afterQuote {
                try appendRow()
            }
            return rows
        }
    }
}
