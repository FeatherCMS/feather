import Application
import UserDomain

func checkPasswordHash(
    using passwordHasher: any PasswordHasher,
    original: String,
    hash: String
) async throws -> Bool {
    try await passwordHasher.verify(original, hash: hash)
}

func hashPassword(
    using passwordHasher: any PasswordHasher,
    original: String
) async throws -> String {
    try await passwordHasher.hash(original)
}

func generateToken(
    byteCount: Int = 32
) -> String {
    precondition(byteCount > 0)

    var rng = SystemRandomNumberGenerator()
    let bytes = (0..<byteCount)
        .map { _ in
            UInt8.random(in: .min ... .max, using: &rng)
        }

    let table = Array(
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
    )
    var output = ""
    var i = 0

    while i < bytes.count {
        let b0 = bytes[i]
        let b1 = i + 1 < bytes.count ? bytes[i + 1] : 0
        let b2 = i + 2 < bytes.count ? bytes[i + 2] : 0

        output.append(table[Int(b0 >> 2)])
        output.append(table[Int((b0 & 0b00000011) << 4 | b1 >> 4)])

        if i + 1 < bytes.count {
            output.append(table[Int((b1 & 0b00001111) << 2 | b2 >> 6)])
        }
        if i + 2 < bytes.count {
            output.append(table[Int(b2 & 0b00111111)])
        }

        i += 3
    }
    return output
}
