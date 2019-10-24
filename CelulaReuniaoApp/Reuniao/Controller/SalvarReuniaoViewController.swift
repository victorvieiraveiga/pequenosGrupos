//
//  SalvarReuniaoViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 24/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class SalvarReuniaoViewController: UIViewController {
    
    @IBOutlet weak var txtObservacoes: UITextField!
    @IBOutlet weak var dtReuniao: UILabel!
    
    var dataReuniao : String   = ""
    var participantes : [String] = []
    var idCelula: String = ""
    var partDados : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        dtReuniao.text = dataReuniao

        setupNotificationDefaults()
    }
    
    
//    func ChamaNotificacao () {
//
//        let center = UNUserNotificationCenter.current()
//        //        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
//        //        }
//
//        let content = UNMutableNotificationContent ()
//        content.title = "Reuniao Criada"
//        content.body = "Não esqueça de enviar seu relatório."
//
//        let date = Date().addingTimeInterval(5)
//        let dateComponentes = Calendar.current.dateComponents([.year,.month,.day], from: date)
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentes, repeats: false)
//
//        let uuidString = UUID().uuidString
//        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
//
//        center.add(request) { (error) in
//            if error != nil {
//                print ("erro notificacao.")
//            }
//        }
//    }
    
    @IBAction func salvar_reuniao(_ sender: Any) {

        for item in participantes {
            partDados = partDados + item + ", "
        }
        do  {
            let database = Database.database().reference()
            
            let autenticacao = Auth.auth()
            let usuarioLogado = autenticacao.currentUser?.uid
            
            let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuarioLogado)
            
            celula.observe(DataEventType.childAdded) { (snapshot) in
                let celulas = snapshot.value as! NSDictionary
                
                if celulas["lider"] != nil {
                        let celulaNome = celulas["lider"]
                    
            let reuniao = database.child("reuniao")
                    let reuniaoDados = ["idCelula" : self.idCelula, "dataReuniao": self.dtReuniao.text, "participantes" : self.partDados, "observacao" : self.txtObservacoes.text, "celulaNome": celulaNome] as [String : Any]
            reuniao.childByAutoId().setValue(reuniaoDados)
            //self.exibeMensagemAlerta(titulo: "Sucesso.", mensagem: "Reunião salva.")
                    
           self.mostrarNotificacao(data: self.dtReuniao.text)
            
            //self.ChamaNotificacao()
            self.performSegue(withIdentifier: "ExibeReuniao", sender: nil)
                }
            }
        }catch {
            self.exibeMensagemAlerta(titulo: "Erro", mensagem: "Erro ao salvar participante ")
        }
    }
    
    @IBAction func esconde_teclado_Obs(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    func exibeMensagemAlerta (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(oKAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
}

extension SalvarReuniaoViewController : UICollectionViewDataSource ,UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participantes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticipantesCell", for: indexPath) as! ParticipantesCellCollectionViewCell

        cell.lblPartNome.text = participantes[indexPath.row]

        return cell
    }
}

extension SalvarReuniaoViewController {
    func mostrarNotificacao(data: String?) {
        let content = UNMutableNotificationContent()

            content.title = "Reunião Pequenos Grupos"
            content.body = "Não esqueça de Enviar seu Relatório."

            content.subtitle = "Dia: " + data!
            content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let identifier = "reuniao"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func setupNotificationDefaults() {
        UNUserNotificationCenter.current().delegate = self
    }
}

extension SalvarReuniaoViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
