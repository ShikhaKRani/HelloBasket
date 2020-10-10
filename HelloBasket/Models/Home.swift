//
//  Home.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 09/10/20.
//

import Foundation


struct HomeModel: Codable {
    let banners: [HomeBanners]?
    let categories: [HomeCategories]?
    let sections: [HomeSections]?
    
//    let others: [HomeOthers]?

    //    let otherbanners: [OtherBanners]?
}

struct HomeBanners: Codable {
    let image: String?
    let type: String?
    let cat_id: Int?
//    let subcat_id: Int?
    
}

struct HomeCategories: Codable {
    let id: Int?
    let name: String?
    let image: String?
}


struct HomeSections: Codable {

       let id: Int?
       let creator_id: Int?
       let title: String?
       let startdate: String?
       let enddate: String?
       let description: String?
       let venue_name: String?
       let venue_adderss: String?
       let lat: String?
       let lang: String?
       let header_image: String?
       let small_image: String?
       let tnc: String?
       let priority: Int?
       let rating: Int?
       let per_person_text: String?
       let time_to_start: String?
       let away: Int?
       let avgreviews: [avgreviewsModel]?
    
}


struct HomeOthers: Codable {
    
    let id: Int?
    let name: String?
    let cover_image: String?
    let small_image: String?
    let istop: Int?
    let about: String?
    let type: String?
    
    let event: [eventModel]?
    let banners: [HomeBanners]?
    
//    let restaurant: [restaurantModel]?
//    let party: [PartyModel]?
}

struct eventModel: Codable {
    let id: Int?
    let creator_id: Int?
    let title: String?
    let startdate: String?
    let enddate: String?
    let description: String?
    let venue_name: String?
    let venue_adderss: String?
    let lat: String?
    let lang: String?
    let header_image: String?
    let small_image: String?
    let tnc: String?
    let priority: Int?
    let rating: String?
    let per_person_text: String?
    let time_to_start: String?
    let away: Int?
    let avgreviews: [avgreviewsModel]?
    
}


struct avgreviewsModel: Codable {
    let rating: String?
    let reviews: Int?
}

