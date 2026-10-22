import AuthModule

extension AuthModule.Authorization.TokenAuth {
    static func generateToken(byteCount: Int = 32) -> String {
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
        var index = 0

        while index < bytes.count {
            let first = bytes[index]
            let second = index + 1 < bytes.count ? bytes[index + 1] : 0
            let third = index + 2 < bytes.count ? bytes[index + 2] : 0

            output.append(table[Int(first >> 2)])
            output.append(table[Int((first & 0b00000011) << 4 | second >> 4)])

            if index + 1 < bytes.count {
                output.append(
                    table[Int((second & 0b00001111) << 2 | third >> 6)]
                )
            }
            if index + 2 < bytes.count {
                output.append(table[Int(third & 0b00111111)])
            }
            index += 3
        }
        return output
    }
}
