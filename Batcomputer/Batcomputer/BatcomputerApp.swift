import SwiftUI

@main
struct BatcomputerApp: App {
    struct Superhero: Codable, Identifiable {
        let id: Int
        let name: String
        let intelligence: Int
        let strength: Int
        let speed: Int
        let durability: Int
        let power: Int
        let combat: Int
        let fullName: String? // Changed to camelCase
        let alterEgos: [String]? //  an array of Strings
        let aliases: [String]? //  an array of Strings
        let placeOfBirth: String? // Changed to camelCase
        let firstAppearance: String? // Changed to camelCase
        let publisher: String
        let alignment: String?
        let gender: String?
        let race: String?
        let height: [String]? //  an array of Strings
        let weight: [String]? //  an array of Strings
        let eyeColor: String? // Changed to camelCase
        let hairColor: String? // Changed to camelCase
        let occupation: String?
        let base: String?
        let groupAffiliation: [String]? //  an array of Strings
        let relatives: String?
        let url: String?

        enum CodingKeys: String, CodingKey {
            case id, name, intelligence, strength, speed, durability, power, combat, publisher, alignment, gender, race, occupation, base, url
            case fullName = "full_name"
            case alterEgos = "alter_egos"
            case aliases
            case placeOfBirth = "place_of_birth"
            case firstAppearance = "first_appearance"
            case eyeColor = "eye_color"
            case hairColor = "hair_color"
            case groupAffiliation = "group_affiliation"
            case relatives
            case height
            case weight
        }

        // Custom init for decoding arrays from JSON strings
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.intelligence = try container.decode(Int.self, forKey: .intelligence)
            self.strength = try container.decode(Int.self, forKey: .strength)
            self.speed = try container.decode(Int.self, forKey: .speed)
            self.durability = try container.decode(Int.self, forKey: .durability)
            self.power = try container.decode(Int.self, forKey: .power)
            self.combat = try container.decode(Int.self, forKey: .combat)
            self.fullName = try container.decodeIfPresent(String.self, forKey: .fullName) // Now using camelCase directly

            self.placeOfBirth = try container.decodeIfPresent(String.self, forKey: .placeOfBirth)
            self.firstAppearance = try container.decodeIfPresent(String.self, forKey: .firstAppearance)
            self.publisher = try container.decode(String.self, forKey: .publisher)
            self.alignment = try container.decodeIfPresent(String.self, forKey: .alignment)
            self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
            self.race = try container.decodeIfPresent(String.self, forKey: .race)
            self.eyeColor = try container.decodeIfPresent(String.self, forKey: .eyeColor)
            self.hairColor = try container.decodeIfPresent(String.self, forKey: .hairColor)
            self.occupation = try container.decodeIfPresent(String.self, forKey: .occupation)
            self.base = try container.decodeIfPresent(String.self, forKey: .base)
            self.url = try container.decodeIfPresent(String.self, forKey: .url)
            self.relatives = try container.decodeIfPresent(String.self, forKey: .relatives) // Still assuming single string

            // --- DECODING JSON STRINGS TO SWIFT ARRAYS ---
            // Helper function to decode a JSON string into a Swift array
            func decodeStringToArray<T: Decodable>(key: CodingKeys) -> T? {
                if let jsonString = try? container.decodeIfPresent(String.self, forKey: key),
                   let data = jsonString.data(using: .utf8) {
                    // Replace single quotes with double quotes for valid JSON, if necessary (from MySQL)
                    let cleanedData = String(data: data, encoding: .utf8)?
                                        .replacingOccurrences(of: "'", with: "\"")
                                        .data(using: .utf8) ?? Data()
                    return try? JSONDecoder().decode(T.self, from: cleanedData)
                }
                return nil
            }

            self.alterEgos = decodeStringToArray(key: .alterEgos) ?? [] // Default to empty array if decoding fails
            self.aliases = decodeStringToArray(key: .aliases) ?? []
            self.height = decodeStringToArray(key: .height) ?? []
            self.weight = decodeStringToArray(key: .weight) ?? []
            self.groupAffiliation = decodeStringToArray(key: .groupAffiliation) ?? []
        }
    }

    // For sending new superhero data (POST request)
    // Note: When sending, you will need to encode Swift arrays back into JSON strings.
    struct NewSuperhero: Codable {
        let name: String
        let intelligence: Int
        let strength: Int
        let speed: Int
        let durability: Int
        let power: Int
        let combat: Int
        let fullName: String // Swift camelCase
        let alterEgos: [String]? // Swift array
        let aliases: [String]?
        let placeOfBirth: String?
        let firstAppearance: String?
        let publisher: String
        let alignment: String?
        let gender: String?
        let race: String?
        let height: [String]?
        let weight: [String]?
        let eyeColor: String?
        let hairColor: String?
        let occupation: String?
        let base: String?
        let groupAffiliation: [String]?
        let relatives: String?
        let url: String?

        enum CodingKeys: String, CodingKey {
            case name, intelligence, strength, speed, durability, power, combat, publisher, alignment, gender, race, occupation, base, url
            case fullName = "full-name" // Maps to Flask's "full-name"
            case alterEgos = "alter-egos"
            case aliases
            case placeOfBirth = "place-of-birth"
            case firstAppearance = "first-appearance"
            case eyeColor = "eye-color"
            case hairColor = "hair-color"
            case groupAffiliation = "group-affiliation"
            case relatives
            case height
            case weight
        }

        // Custom encode function to convert Swift arrays to JSON strings for Flask
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(intelligence, forKey: .intelligence)
            try container.encode(strength, forKey: .strength)
            try container.encode(speed, forKey: .speed)
            try container.encode(durability, forKey: .durability)
            try container.encode(power, forKey: .power)
            try container.encode(combat, forKey: .combat)
            try container.encode(fullName, forKey: .fullName)
            try container.encodeIfPresent(placeOfBirth, forKey: .placeOfBirth)
            try container.encodeIfPresent(firstAppearance, forKey: .firstAppearance)
            try container.encode(publisher, forKey: .publisher)
            try container.encodeIfPresent(alignment, forKey: .alignment)
            try container.encodeIfPresent(gender, forKey: .gender)
            try container.encodeIfPresent(race, forKey: .race)
            try container.encodeIfPresent(eyeColor, forKey: .eyeColor)
            try container.encodeIfPresent(hairColor, forKey: .hairColor)
            try container.encodeIfPresent(occupation, forKey: .occupation)
            try container.encodeIfPresent(base, forKey: .base)
            try container.encodeIfPresent(url, forKey: .url)
            try container.encodeIfPresent(relatives, forKey: .relatives)

            // Encode Swift arrays to JSON strings
            if let alterEgos = alterEgos {
                let data = try JSONEncoder().encode(alterEgos)
                try container.encode(String(data: data, encoding: .utf8), forKey: .alterEgos)
            }
            if let aliases = aliases {
                let data = try JSONEncoder().encode(aliases)
                try container.encode(String(data: data, encoding: .utf8), forKey: .aliases)
            }
            if let height = height {
                let data = try JSONEncoder().encode(height)
                try container.encode(String(data: data, encoding: .utf8), forKey: .height)
            }
            if let weight = weight {
                let data = try JSONEncoder().encode(weight)
                try container.encode(String(data: data, encoding: .utf8), forKey: .weight)
            }
            if let groupAffiliation = groupAffiliation {
                let data = try JSONEncoder().encode(groupAffiliation)
                try container.encode(String(data: data, encoding: .utf8), forKey: .groupAffiliation)
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView() // Your main UI view
        }
    }
}


