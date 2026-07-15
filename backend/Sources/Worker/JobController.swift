//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 18..
//

import FeatherMail
import Jobs

struct EmailService {
    let client: any MailClient

    func sendEmail(
        to: [String],
        from: String,
        subject: String,
        message: String
    ) async throws {
        try await client.send(
            .init(
                from: .init(from),
                to: to.map { .init($0) },
                subject: subject,
                body: .plainText(message)
            )
        )
    }
}

struct JobController {
    // parameters required to run email job
    struct EmailParameters: JobParameters {
        static let jobName = "send_email"
        let to: [String]
        let from: String
        let subject: String
        let message: String
    }

    init(queue: some JobQueueProtocol, emailService: EmailService) {
        // This function demonstrates two different ways to register a job
        // Register Job with predefined job identifier
        queue.registerJob(parameters: EmailParameters.self) {
            parameters,
            context in
            try await emailService.sendEmail(
                to: parameters.to,
                from: parameters.from,
                subject: parameters.subject,
                message: parameters.message
            )
        }
    }
}
