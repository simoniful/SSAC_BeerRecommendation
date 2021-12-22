//
//  Model.swift
//  SSAC_BeerRecommendation
//
//  Created by Sang hun Lee on 2021/12/20.
//

import Foundation
import Alamofire

struct Info: Codable {
    let id: Int
    let name, tagline, firstBrewed, description: String
    let imageURL: String?
    let abv: Double
    let ibu: Double?
    let ebc: Double?
    let srm: Double?
    let ph: Double?
    let foodPairing: [String]
    let brewersTips: String

    enum CodingKeys: String, CodingKey {
        case id, name, tagline
        case firstBrewed = "first_brewed"
        case description = "description"
        case imageURL = "image_url"
        case abv, ibu
        case ebc, srm, ph
        case foodPairing = "food_pairing"
        case brewersTips = "brewers_tips"
    }
}

extension Info {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Info.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int? = nil,
        name: String? = nil,
        tagline: String? = nil,
        firstBrewed: String? = nil,
        description: String? = nil,
        imageURL: String?? = nil,
        abv: Double? = nil,
        ibu: Double?? = nil,
        ebc: Double?? = nil,
        srm: Double?? = nil,
        ph: Double?? = nil,
        foodPairing: [String]? = nil,
        brewersTips: String? = nil
    ) -> Info {
        return Info (
            id: id ?? self.id,
            name: name ?? self.name,
            tagline: tagline ?? self.tagline,
            firstBrewed: firstBrewed ?? self.firstBrewed,
            description: description ?? self.description,
            imageURL: imageURL ?? self.imageURL,
            abv: abv ?? self.abv,
            ibu: ibu ?? self.ibu,
            ebc: ebc ?? self.ebc,
            srm: srm ?? self.srm,
            ph: ph ?? self.ph,
            foodPairing: foodPairing ?? self.foodPairing,
            brewersTips: brewersTips ?? self.brewersTips
        )
    }

    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
