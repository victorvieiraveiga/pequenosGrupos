//
//  MapaDataManager.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 11/09/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import Foundation
import MapKit

//class MapaDataManager: DataManager {
//    fileprivate var items: [Participante] = []
//    
//    func fetch(completion: @escaping (_ annotations: [Participante]) -> ()) {
//        let manager = //RestauranteDataManager()
//        manager.fetch(by: "Rio de Janeiro") { (items) in
//            self.items = items
//            completion(self.items)
//        }
//    }
//    
//    func numberOfItems() -> Int {
//        return items.count
//    }
//    
//    func localizacaoMapa(at index: IndexPath) -> RestauranteItem {
//        return items[index.item]
//    }
//    
//    func regiaoAtual(latDelta: CLLocationDegrees, longDelta: CLLocationDegrees) -> MKCoordinateRegion {
//        guard let item = items.first else { return MKCoordinateRegion() }
//        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
//        return MKCoordinateRegion(center: item.coordinate, span: span)
//    }
//}

