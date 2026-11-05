import NewsletterModule

extension Campaign.Subscriber.Import.Interactor {
    struct Default: Interface {
        let repository: any Campaign.Subscriber.Import.Repository.Interface

        func run(
            newsletterId: String,
            csv: String
        ) async throws -> Campaign.Subscriber.Import.Result {
            let records = try Campaign.Subscriber.Import.CSVParser.parse(csv)
            let existingEmails = try await repository.existingEmails(
                newsletterId: newsletterId
            )
            var seenEmails: Set<String> = []
            var imported = 0
            var skipped = 0

            for record in records {
                let email = record.email.lowercased()
                guard seenEmails.insert(email).inserted,
                    !existingEmails.contains(email)
                else {
                    skipped += 1
                    continue
                }
                do {
                    try await repository.create(
                        newsletterId: newsletterId,
                        record: record
                    )
                    imported += 1
                }
                catch {
                    throw ImportError.rowFailed(
                        line: record.line,
                        imported: imported,
                        message: String(describing: error)
                    )
                }
            }

            return Campaign.Subscriber.Import.Result(
                imported: imported,
                skipped: skipped
            )
        }
    }
}

private enum ImportError: Error, CustomStringConvertible {
    case rowFailed(line: Int, imported: Int, message: String)

    var description: String {
        switch self {
        case .rowFailed(let line, let imported, let message):
            return
                "Import stopped at row \(line) after adding \(imported) subscribers: \(message)"
        }
    }
}
