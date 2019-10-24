//
//  MapaParticipantes.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 11/09/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import SDWebImage

class MapaParticipantes: UIViewController, CLLocationManagerDelegate  {
    
    @IBOutlet weak var mapaView: MKMapView!
    
    var participante : [Participante] = []
    var celula : [Celulas]  = []
    var participanteSelecionado: Participante?
    var enderecoCelPrincipal : String?
    var gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    
//    var endereco : String = "Rua Sericita, 60, Freguesia"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapaView.delegate = self
        gerenciadorLocalizacao.delegate = self
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestAlwaysAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        //Carrega array com outras celulas cadastradas
        
        
        //Adiciona Celula Principal
        adicionaAnnotationCelulaPrincipal()
        
        
        //adiciona participantes no mapa
        for partItem in participante {
            //adicionaAnnotations(endereco: partItem.endereco, nome: partItem.nome)
            AddAnnotationGeneric (endereco: partItem.endereco, nome: partItem.nome,identificador: "participante")
        }
        
        //adiciona annotatiosn de outras celulas
        CarregaOutrasCelulas ()
}
    
    func CarregaOutrasCelulas () {
        //let autenticacao = Auth.auth()
       // let usuarioLogado = autenticacao.currentUser!.uid
        let database = Database.database().reference()
        let celulas = database.child("celula")
        celulas.observe(DataEventType.childAdded) { (dataSnapshot) in
            
            let celulaDados = dataSnapshot.value as! NSDictionary
            
            let endereco = celulaDados["endereco"]
            let lider = celulaDados["lider"]
            let anfitriao = celulaDados ["anfitriao"]
            let dia = celulaDados ["dia"]
            let horario = celulaDados["horario"]
            let idCelula = dataSnapshot.key
            //let idUsuario = celulaDados ["idUsuario"]
            let tipoGrupo = celulaDados["tipoGrupo"]
            
            self.celula = [Celulas( uidCelula: idCelula, nomeLider: lider as! String, nomeAnfitriao: anfitriao as! String, endCelula: endereco as! String, diaCelula: dia as! String, horarioCelula: horario as! String, tipoGrupo: tipoGrupo as! String)]
            
            for celItem in self.celula {
                
                if let endCelPrinc = self.enderecoCelPrincipal {
                    if celItem.endCelula != endCelPrinc {
                
                // self.adicionaAnnotations (endereco: celItem.endCelula, nome: celItem.nomeLider)
                        self.AddAnnotationGeneric (endereco: celItem.endCelula, nome: "Pequeno Grupo Aqui", identificador: "Pequeno Grupo Aqui" )
                    }
                }
            }

            }
        }
    
    func adicionaAnnotationCelulaPrincipal () {
        let autenticacao = Auth.auth()
        let usuarioLogado = autenticacao.currentUser!.uid
        let database = Database.database().reference()
        let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuarioLogado)
        
        celula.observe(DataEventType.childAdded) { (dataSnapshot) in
            let celulaDados = dataSnapshot.value as! NSDictionary
            let endereco = celulaDados["endereco"]
            //let nome = celulaDados["lider"]
            let geocoder = CLGeocoder()
            
            self.enderecoCelPrincipal = celulaDados["endereco"] as? String
            geocoder.geocodeAddressString(endereco as! String) { (placeMarks, error) in
                if error == nil{
                    let placemark  = placeMarks?.first
                    let latitude : CLLocationDegrees = (placemark?.location?.coordinate.latitude)!
                    let longitude : CLLocationDegrees = (placemark?.location?.coordinate.longitude)!
                   // let coordenadas : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    
                    let deltaLatitude : CLLocationDegrees = 0.01
                    let deltaLongitude : CLLocationDegrees = 0.01
                    let areaVisual : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
                    let localizacao : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    let regiao : MKCoordinateRegion = MKCoordinateRegion(center: localizacao, span: areaVisual )
                    self.mapaView.setRegion(regiao, animated: true)
                }else{
                    self.exibeMensagemAlerta(titulo: "Erro", mensagem: "Endereço Não localizado.")
                }
            }
            
            self.AddAnnotationGeneric(endereco: endereco as! String, nome: "Pequeno Grupo Principal", identificador:"Pequeno Grupo Principal" )
        }
}

    func AddAnnotationGeneric (endereco: String, nome: String, identificador: String ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(endereco) { (placeMarks, error) in
            let annotation  = MKPointAnnotation()
            if error == nil{
                let placemark  = placeMarks?.first
                let latitude : CLLocationDegrees = (placemark?.location?.coordinate.latitude)!
                let longitude : CLLocationDegrees = (placemark?.location?.coordinate.longitude)!
                let coordenadas : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                
                annotation.title = nome
                annotation.subtitle = endereco
                annotation.coordinate = coordenadas
                
                self.mapaView.addAnnotation(annotation)
                
            }else{
                self.exibeMensagemAlerta(titulo: "Erro", mensagem: "Endereço Não localizado " + endereco + " Nome: " + nome)
            }
        }
    }
    
//    func adicionaAnnotations (endereco: String, nome: String) {
//
//        let geocoder = CLGeocoder()
//
//        geocoder.geocodeAddressString(endereco) { (placeMarks, error) in
//
//            if error == nil{
//
//                let placemark  = placeMarks?.first
//                let latitude : CLLocationDegrees = (placemark?.location?.coordinate.latitude)!
//                let longitude : CLLocationDegrees = (placemark?.location?.coordinate.longitude)!
//
//                let coordenadas : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
//
//                var annotationView: MKAnnotationView?
//
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = coordenadas
//                annotation.title = nome
//                annotation.subtitle = endereco
//                annotationView?.annotation = annotation
//                annotationView?.image =  UIImage(named: "custom-annotation")
//
//                self.mapaView.addAnnotation(annotation)
//
//                print (coordenadas.latitude)
//                print (coordenadas.longitude)
//            }else{
//                self.exibeMensagemAlerta(titulo: "Erro", mensagem: "Endereço Não localizado " + endereco + " Nome: " + nome)
//            }
//        }
//    }
    
    
//    func adicionaAnnotationsOutrasCelulas (endereco: String, nome: String) {
//
//        let geocoder = CLGeocoder()
//
//        geocoder.geocodeAddressString(endereco) { (placeMarks, error) in
//
//            if error == nil{
//
//                let placemark  = placeMarks?.first
//                let latitude : CLLocationDegrees = (placemark?.location?.coordinate.latitude)!
//                let longitude : CLLocationDegrees = (placemark?.location?.coordinate.longitude)!
//
//                let coordenadas : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
//
//                var annotationView: MKAnnotationView?
//
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = coordenadas
//                annotation.title = nome
//                annotation.subtitle = endereco
//                annotationView?.annotation = annotation
//                annotationView?.image =  UIImage(named: "custom-annotation")
//
//                self.mapaView.addAnnotation(annotation)
//
//                print (coordenadas.latitude)
//                print (coordenadas.longitude)
//            }else{
//                self.exibeMensagemAlerta(titulo: "Erro", mensagem: "Endereço Não localizado " + endereco + " Nome: " + nome)
//            }
//        }
//    }


    func exibeMensagemAlerta (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(oKAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}

extension MapaParticipantes : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapaView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if let tittle = annotation.title, tittle == "Pequeno Grupo Principal" {
            annotationView?.image = UIImage(named: "pg_icon_Vermelho48")
        } else if let tittle = annotation.title, tittle == "Pequeno Grupo Aqui" {
            annotationView?.image = UIImage(named: "pg_icon_Azul40")
        }else {
            
            
            annotationView?.image = UIImage(named: "pessoa4")
        }
        
        
        
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func RetornaImagem (url: String) -> UIImageView {
        
        let urlImage = URL(string: url)
        var imagem : UIImageView?
        
        imagem!.sd_setImage(with: urlImage, completed: { (image, erro, cache, url) in
            })
        return imagem!
        }
}









