//
//  File.swift
//
//
//  Created by Tibor Bodecs on 2020. 11. 20..
//

import ViewKit

extension FormFieldStringOption {

    static var locales: [FormFieldStringOption] {
        Locale.availableIdentifiers
            .map { .init(key: $0, label: Locale.autoupdatingCurrent.localizedString(forIdentifier: $0) ?? $0) }
            .sorted(by: { $0.label < $1.label })
    }

    static var gmtTimezones: [FormFieldStringOption] {
        TimeZone.knownTimeZoneIdentifiers
            .compactMap { TimeZone.init(identifier: $0) }
            .sorted(by: { $0.secondsFromGMT() < $1.secondsFromGMT() })
            .map { tz in
                let id = tz.identifier
//                let abbrev = tz.abbreviation() ?? id
                //let city = tz.identifier.split(separator: "/").dropFirst().joined(separator: ", ").replacingOccurrences(of: "_", with: " ")
                //let city = tz.identifier.replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: "/", with: ", ")
                let city = tz.identifier.replacingOccurrences(of: "_", with: " ").split(separator: "/").reversed().joined(separator: ", ")
                let name = tz.localizedName(for: .standard, locale: Locale.autoupdatingCurrent) ?? id
                let shortName = name.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
                let seconds = tz.secondsFromGMT()
                let hours = seconds / 3600
                let minutes = abs(seconds / 60) % 60
                let gmt = String(format: "%+.2d:%.2d", hours, minutes)
                return .init(key: id, label: "GMT\(gmt) - \(city) (\(shortName))")
            }
    }
    
    static var uniqueTimeZones: [FormFieldStringOption] {
        return [
            "Pacific/Pago_Pago": "GMT-11:00 - Midway Island, Samoa",
            "Pacific/Honolulu": "GMT-10:00 - Hawaii",
            "America/Anchorage": "GMT-9:00 - Alaska",
            "America/Tijuana": "GMT-8:00 - Chihuahua, La Paz, Mazatlan",
            "America/Los_Angeles": "GMT-8:00 - Pacific Time (US & Canada), Tijuana",
            "America/Phoenix": "GMT-7:00 - Arizona",
            "America/Denver": "GMT-7:00 - Mountain Time (US & Canada)",
            "America/Costa_Rica": "GMT-6:00 - Central America",
            "America/Chicago": "GMT-6:00 - Central Time (US & Canada)",
            "America/Mexico_City": "GMT-6:00 - Guadalajara, Mexico City, Monterrey",
            "America/Regina": "GMT-6:00 - Saskatchewan",
            "America/Bogota": "GMT-5:00 - Bogota, Lima, Quito",
            "America/New_York": "GMT-5:00 - Eastern Time (US & Canada)",
            "America/Fort_Wayne": "GMT-5:00 - Indiana (East)",
            "America/Caracas": "GMT-4:00 - Caracas, La Paz",
            "America/Halifax": "GMT-4:00 - Atlantic Time (Canada), Brasilia, Greenland",
            "America/Santiago": "GMT-4:00 - Santiago",
            "America/St_Johns": "GMT-3:30 - Newfoundland",
            "America/Argentina/Buenos_Aires": "GMT-3:00 - Buenos Aires, Georgetown",
            "America/Noronha": "GMT-2:00 - Fernando de Noronha",
            "Atlantic/Azores": "GMT-1:00 - Azores",
            "Atlantic/Cape_Verde": "GMT-1:00 - Cape Verde Is.",
            "Etc/UTC": "GMT - UTC",
            "Africa/Casablanca": "GMT+0:00 - Casablanca, Monrovia",
            "Europe/Dublin": "GMT+0:00 - Dublin, Edinburgh, London",
            "Europe/Amsterdam": "GMT+1:00 - Amsterdam, Berlin, Rome, Stockholm, Vienna",
            "Europe/Prague": "GMT+1:00 - Belgrade, Bratislava, Budapest, Prague",
            "Europe/Paris": "GMT+1:00 - Brussels, Copenhagen, Madrid, Paris",
            "Europe/Warsaw": "GMT+1:00 - Sarajevo, Skopje, Warsaw, Zagreb",
            "Africa/Lagos": "GMT+1:00 - West Central Africa",
            "Europe/Istanbul": "GMT+2:00 - Athens, Beirut, Bucharest, Istanbul",
            "Africa/Cairo": "GMT+2:00 - Cairo, Egypt",
            "Africa/Maputo": "GMT+2:00 - Harare",
            "Europe/Kiev": "GMT+2:00 - Helsinki, Kiev, Riga, Sofia, Tallinn, Vilnius",
            "Asia/Jerusalem": "GMT+2:00 - Jerusalem",
            "Africa/Johannesburg": "GMT+2:00 - Pretoria",
            "Asia/Baghdad": "GMT+3:00 - Baghdad",
            "Asia/Riyadh": "GMT+3:00 - Kuwait, Nairobi, Riyadh",
            "Europe/Moscow": "GMT+3:00 - Moscow, St. Petersburg, Volgograd",
            "Asia/Tehran": "GMT+3:30 - Tehran",
            "Asia/Dubai": "GMT+4:00 - Abu Dhabi, Muscat",
            "Asia/Baku": "GMT+4:00 - Baku, Tbilisi, Yerevan",
            "Asia/Kabul": "GMT+4:30 - Kabul",
            "Asia/Karachi": "GMT+5:00 - Islamabad, Karachi, Tashkent",
            "Asia/Yekaterinburg": "GMT+5:00 - Yekaterinburg",
            "Asia/Kolkata": "GMT+5:30 - Chennai, Calcutta, Mumbai, New Delhi",
            "Asia/Kathmandu": "GMT+5:45 - Katmandu",
            "Asia/Almaty": "GMT+6:00 - Almaty, Novosibirsk",
            "Asia/Dhaka": "GMT+6:00 - Astana, Dhaka, Sri Jayawardenepura",
            "Asia/Rangoon": "GMT+6:30 - Rangoon",
            "Asia/Bangkok": "GMT+7:00 - Bangkok, Hanoi, Jakarta",
            "Asia/Krasnoyarsk": "GMT+7:00 - Krasnoyarsk",
            "Asia/Hong_Kong": "GMT+8:00 - Beijing, Chongqing, Hong Kong, Urumqi",
            "Asia/Irkutsk": "GMT+8:00 - Irkutsk, Ulaan Bataar",
            "Asia/Singapore": "GMT+8:00 - Kuala Lumpur, Perth, Singapore, Taipei",
            "Asia/Tokyo": "GMT+9:00 - Osaka, Sapporo, Tokyo",
            "Asia/Seoul": "GMT+9:00 - Seoul",
            "Asia/Yakutsk": "GMT+9:00 - Yakutsk",
            "Australia/Adelaide": "GMT+9:30 - Adelaide",
            "Australia/Darwin": "GMT+9:30 - Darwin",
            "Australia/Brisbane": "GMT+10:00 - Brisbane, Guam, Port Moresby",
            "Australia/Sydney": "GMT+10:00 - Canberra, Hobart, Melbourne, Sydney, Vladivostok",
            "Asia/Magadan": "GMT+11:00 - Magadan, Soloman Is., New Caledonia",
            "Pacific/Auckland": "GMT+12:00 - Auckland, Wellington",
            "Pacific/Fiji": "GMT+12:00 - Fiji, Kamchatka, Marshall Is.",
            "Pacific/Kwajalein": "GMT+12:00 - International Date Line West",
        ]
        .sorted(by: { TimeZone(identifier: $0.key)!.secondsFromGMT() < TimeZone(identifier: $1.key)!.secondsFromGMT() })
        .map { .init(key: $0, label: $1) }
    }
}
