import ContactDomain
public import ContactModule
public import FeatherApplication
import FeatherMail
public import FeatherModuleKit
import Foundation

import struct Foundation.Date

extension Form.Submit {
    public struct UseCase: FeatherApplication.UseCase {
        private struct MailTemplate: Sendable {
            let mailFrom: String
            let mailTo: String
            let subject: String
            let additionalHeaders: [String]
            let messageBody: String
        }

        private struct ExecutionResult: Sendable {
            let redirectUrl: String?
            let mails: [MailTemplate]
            let mailTemplateValues: [String: String]
        }

        let transaction: any ContextualTransactionExecutor<Scope>
        let jobs: any SendMailJobController
        let events: any EventPublisher

        public init(
            transaction: any ContextualTransactionExecutor<Scope>,
            jobs: any SendMailJobController,
            events: any EventPublisher
        ) {
            self.transaction = transaction
            self.jobs = jobs
            self.events = events
        }

        public func execute(
            input: Input
        ) async throws -> Output {
            let result = try await transaction.run { scope, context in
                guard let form = try await scope.form.findBy(key: input.formKey)
                else {
                    throw Error.formNotFound
                }
                let fields = try await scope.field.listBy(formId: form.id)
                let mails = try await scope.mail.listBy(formId: form.id)
                    .map {
                        MailTemplate(
                            mailFrom: $0.mailFrom,
                            mailTo: $0.mailTo,
                            subject: $0.subject,
                            additionalHeaders: $0.additionalHeaders,
                            messageBody: $0.messageBody
                        )
                    }
                try validate(
                    valuesJSON: input.valuesJSON,
                    against: fields
                )

                let model = Submission.Model.create(
                    formId: form.id,
                    valuesJSON: input.valuesJSON,
                    itemsSnapshotJSON: input.itemsSnapshotJSON,
                    metadataJSON: input.metadataJSON,
                )

                let mailTemplateValues = try await loadMailTemplateValues(
                    formKey: input.formKey,
                    mails: mails,
                    context: context
                )

                _ = try await scope.submission.insert(model)

                return ExecutionResult(
                    redirectUrl: form.redirectUrl,
                    mails: mails,
                    mailTemplateValues: mailTemplateValues
                )
            }

            try await enqueueMailTasks(
                mails: result.mails,
                valuesJSON: input.valuesJSON,
                templateValues: result.mailTemplateValues
            )

            return .init(redirectUrl: result.redirectUrl)
        }

        private func loadMailTemplateValues(
            formKey: String,
            mails: [MailTemplate],
            context: (any TransactionContext)
        ) async throws -> [String: String] {
            guard !mails.isEmpty else { return [:] }

            let providers = try await events.trigger(
                event: Form.Submit.MailTemplateValuesProvider(
                    formKey: formKey
                ),
                using: context
            )
            var values: [String: String] = [:]
            for provider in providers {
                for (key, value) in provider.values where values[key] == nil {
                    values[key] = value
                }
            }
            return values
        }

        private func enqueueMailTasks(
            mails: [MailTemplate],
            valuesJSON: String,
            templateValues: [String: String]
        ) async throws {
            guard
                let data = valuesJSON.data(using: .utf8),
                var values = try JSONSerialization.jsonObject(with: data)
                    as? [String: Any]
            else {
                return
            }
            for (key, value) in templateValues where values[key] == nil {
                values[key] = value
            }

            for mail in mails {
                try await jobs.enqueue(
                    makeMail(
                        from: render(mail.mailFrom, values: values),
                        to: render(mail.mailTo, values: values),
                        subject: render(mail.subject, values: values),
                        additionalHeaders: mail.additionalHeaders.map {
                            render($0, values: values)
                        },
                        body: renderHTML(mail.messageBody, values: values)
                    )
                )
            }
        }

        private func makeMail(
            from: String,
            to: String,
            subject: String,
            additionalHeaders: [String],
            body: String
        ) -> Mail {
            let headers = parseHeaders(additionalHeaders)
            return .init(
                from: .init(from),
                to: [.init(to)],
                cc: headers["cc", default: []].map { .init($0) },
                bcc: headers["bcc", default: []].map { .init($0) },
                replyTo: headers["reply-to", default: []].map { .init($0) },
                subject: subject,
                body: .html(body)
            )
        }

        private func parseHeaders(
            _ values: [String]
        ) -> [String: [String]] {
            values.reduce(into: [:]) { result, line in
                let parts = line.split(separator: ":", maxSplits: 1)
                    .map(String.init)
                guard parts.count == 2 else { return }
                let key = parts[0]
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .lowercased()
                guard ["cc", "bcc", "reply-to"].contains(key) else { return }
                result[key, default: []] += parts[1]
                    .split(separator: ",")
                    .map {
                        $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
            }
        }

        private func render(
            _ template: String,
            values: [String: Any]
        ) -> String {
            values.reduce(template) { result, entry in
                let value = String(describing: entry.value)
                return
                    result
                    .replacingOccurrences(of: "[\(entry.key)]", with: value)
                    .replacingOccurrences(of: "{{\(entry.key)}}", with: value)
            }
        }

        private func renderHTML(
            _ template: String,
            values: [String: Any]
        ) -> String {
            values.reduce(template) { result, entry in
                let value = htmlEscaped(String(describing: entry.value))
                return
                    result
                    .replacingOccurrences(of: "[\(entry.key)]", with: value)
                    .replacingOccurrences(of: "{{\(entry.key)}}", with: value)
            }
        }

        private func htmlEscaped(_ value: String) -> String {
            value
                .replacingOccurrences(of: "&", with: "&amp;")
                .replacingOccurrences(of: "<", with: "&lt;")
                .replacingOccurrences(of: ">", with: "&gt;")
                .replacingOccurrences(of: "\"", with: "&quot;")
                .replacingOccurrences(of: "'", with: "&#39;")
        }

        private func validate(
            valuesJSON: String,
            against fields: [FormField.Model]
        ) throws {
            guard
                let data = valuesJSON.data(using: .utf8),
                let object = try? JSONSerialization.jsonObject(with: data),
                let values = object as? [String: Any]
            else {
                throw Error.invalidValues("Form values must be a JSON object")
            }

            for field in fields {
                guard let value = values[field.key] else {
                    if field.isRequired {
                        throw Error.invalidValues(
                            "Missing required form field: \(field.key)"
                        )
                    }
                    continue
                }

                switch field.type {
                case .text, .textarea:
                    guard value is String else {
                        throw Error.invalidValues(
                            "Invalid value for form field: \(field.key)"
                        )
                    }
                case .select, .radio:
                    guard
                        let stringValue = value as? String,
                        field.allowedValues.contains(where: {
                            $0.value == stringValue
                        })
                    else {
                        throw Error.invalidValues(
                            "Invalid option for form field: \(field.key)"
                        )
                    }
                case .toggle:
                    guard
                        let stringValue = value as? String,
                        ["true", "false"].contains(stringValue)
                    else {
                        throw Error.invalidValues(
                            "Invalid value for form field: \(field.key)"
                        )
                    }
                case .hidden:
                    guard value is String else {
                        throw Error.invalidValues(
                            "Invalid value for form field: \(field.key)"
                        )
                    }
                }
            }
        }

    }
}
