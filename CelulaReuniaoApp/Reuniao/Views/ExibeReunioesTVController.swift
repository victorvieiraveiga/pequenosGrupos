//
//  ExibeReunioesTVController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 09/09/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import UserNotifications

class ExibeReunioesTVController: UITableViewController , UISearchBarDelegate {

    @IBOutlet var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var nomeCelula : String = ""
    
    var reunioes : [ReuniaoItem] = []
    var reunioesCorrente : [ReuniaoItem] = []
    var searchData : [ReuniaoItem]=[]
    var idCelula : String = ""
    
    //var indice : Int = 0
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //autorizacao para notificacoes
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        let logado = VerificaUsuarioLogado()
        
        if logado == "desconectado" {
            performSegue(withIdentifier: "voltaPraHome", sender: logado)
        }
        else {
        
        initialize ()
        alterLayout()
        setUpReunioes()
        //ChamaNotificacao()
        
        //evento para item removido
        let database = Database.database().reference()
        let reunioes = database.child("reuniao")
        
        
        reunioes.observe(DataEventType.childRemoved) { (snapshot) in
            print(snapshot)
            
            var indice = 0
            
            for r in self.reunioesCorrente {
                if r.idReuniao == snapshot.key {
                    self.reunioesCorrente.remove(at: indice)
                    }
                indice = indice + 1
                }
            self.tableView.reloadData()
            }
        }
    }

    func VerificaUsuarioLogado () -> String {
        var logado : String = ""
        
        let autenticacao = Auth.auth()
        
        if let usuariologado = autenticacao.currentUser?.uid {
            logado = "logado"
        }
        else {
            logado = "desconectado"
        }
        return logado
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    func alterLayout() {
        table.tableHeaderView = UIView()
        // search bar in section header
        table.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false // you can show/hide this dependant on your layout
        searchBar.placeholder = "Buscar pela Data"
    }
    
    private func setUpReunioes() {
        self.reunioesCorrente = self.reunioes
    }
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reunioesCorrente = reunioes.filter({ reuniao -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return reuniao.dataReuniao.lowercased().contains(searchText.lowercased())
            case 1:
                if searchText.isEmpty { return  true }
                return reuniao.participantes.lowercased().contains(searchText.lowercased())
//                    animal.category == .dog
//            case 2:
//                if searchText.isEmpty { return animal.category == .cat }
//                return animal.name.lowercased().contains(searchText.lowercased()) &&
//                    animal.category == .cat
            default:
                return false
            }
        })
        table.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            reunioesCorrente = reunioes
        default:
            break
        }
        table.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reunioesCorrente.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuniaoCell: ReuniaoCell = tableView.dequeueReusableCell(withIdentifier: "reuniaoCell", for: indexPath) as! ReuniaoCell
        
        // Configure the cell...
        let reuniao = self.reunioesCorrente[indexPath.row]
        
        let data = reuniao.dataReuniao
        let participantes = reuniao.participantes
        let obs = reuniao.observacoes

        reuniaoCell.txtData.text = data
        reuniaoCell.txtParticipantes.text = participantes
        reuniaoCell.txtObs.text = obs
        
        reuniaoCell.btnShare.tag = indexPath.row
        //reuniaoCell.btnShare.addTarget(self, action: "compartilhar", for: .touchUpInside)
        

        return reuniaoCell
    }
 
    //remove registro
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let reuniao = self.reunioes[indexPath.row]
            
            let database = Database.database().reference()
            //pega id da celula do usuario logado
            let autenticacao = Auth.auth()
            //autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            if let usuarioLogado = autenticacao.currentUser?.uid {
                //let usuarioLogado = usuario?.uid
                let database = Database.database().reference()
                let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuarioLogado)
                
                celula.observe(DataEventType.childAdded, with: { (CelulaSnapshot) in
                    //let dadosCel = CelulaSnapshot.value as! NSDictionary
                    let reuniaoDados = database.child("reuniao").child(reuniao.idReuniao)
                    reuniaoDados.removeValue()
    
                    self.table.reloadData()
                })
            }
        }
    }
    
    @IBAction func compartilhar (sender: UIButton) {
        
        let indice =  sender.tag//self.tableView.indexPathForSelectedRow!
       
        
        let lblCelula = "Celula: "
//        let lblData = "Data do Evento: "
//        let lblPartic = "Participantes: "
        
        let data = self.reunioesCorrente[indice].dataReuniao
        let part = self.reunioesCorrente[indice].participantes
        let obs =  self.reunioesCorrente[indice].observacoes
        let celulaNome = self.reunioesCorrente[indice].celulaNome
    
        
        
        let atribute1 = NSMutableAttributedString(string: lblCelula)
        atribute1.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 8))
        atribute1.addAttribute(.font, value: UIFont.fontNames(forFamilyName:"Avenir Black"), range: NSRange(location: 0, length: 8))
        
        let conteudo =  lblCelula + "\(celulaNome)\n\n" + "Data do Evento: " + "\(data)\n\n" + "Participantes: " + "\(part)\n\n" + "Observações: " + obs
        
        PreparaEmail (texto: conteudo)
         //let activityController = UIActivityViewController(activityItems: [conteudo] , applicationActivities: nil)
         //activityController.popoverPresentationController?.sourceView = self.view
        // self.present(activityController, animated: true, completion: nil)
    }
    
    func PreparaEmail (texto: String) {
        guard MFMailComposeViewController.canSendMail() else {return}
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
        composer.setSubject("Relatório de Pequeno Grupo")
        
        composer.setMessageBody(texto, isHTML: false)
        
        present(composer, animated: true)
    }
    
    func ChamaNotificacao () {
        
        let center = UNUserNotificationCenter.current()
        //        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        //        }
        
        let content = UNMutableNotificationContent ()
        content.title = "Reuniao Criada"
        content.body = "Não esqueça de enviar seu relatório."
        
        let date = Date().addingTimeInterval(5)
        let dateComponentes = Calendar.current.dateComponents([.year,.month,.day], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentes, repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil {
                print ("erro notificacao.")
            }
        }
    }
    
}

extension ExibeReunioesTVController : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _  = error {
            controller.dismiss(animated: true)
        }
        
        switch result {
        case .cancelled:
            print ("Cancelado")
        case .failed:
            print ("Falha ao enviar")
        case .saved:
            print ("Salvo")
        case .sent:
            print ("Enviado")
      
        }
         controller.dismiss(animated: true)
    }
}

    

extension ExibeReunioesTVController {
    func initialize () {
        let database = Database.database().reference()
        //pega id da celula do usuario logado
        let autenticacao = Auth.auth()
        //autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
        if let usuarioLogado = autenticacao.currentUser?.uid {
            //let usuarioLogado = usuario?.uid
            let database = Database.database().reference()
            let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuarioLogado)
            
            celula.observe(DataEventType.childAdded, with: { (celulaSnapshot) in
                let dadosCel = celulaSnapshot.value as! NSDictionary
                
                self.idCelula = dadosCel["idCelula"] as! String // pega o id da celula do usuario logado
                
                let reunioes = database.child("reuniao").queryOrdered(byChild: "idCelula").queryEqual(toValue: self.idCelula)//.queryOrdered(byChild: "dataReuniao")//busca as reuniao da celula do usuario logado.
                //let reuniaoOrdenada = reunioes.queryOrdered(byChild: "dataReuniao")
                
                reunioes.observe(DataEventType.childAdded, with: { (reuniaoSnapshot) in
                    // print (usuSnapshot)
                    
                    let dados = reuniaoSnapshot.value as! NSDictionary
                    
                    
                    let data = dados["dataReuniao"] as! String
                    let observacao = dados["observacao"] as! String
                    let participantes = dados["participantes"] as! String
                    let celulaNome = dados["celulaNome"] as! String
                    let idReuniao = reuniaoSnapshot.key
                    let idCelula = self.idCelula
                    
                    
                    
                    let reunioesDados = ReuniaoItem(dataReuniao: data, participantes: participantes, observacoes: observacao, idCelula: idCelula, idReuniao: idReuniao, celulaNome:celulaNome )
                    
                    self.reunioes.append(reunioesDados)
                    
//                    self.tableViewData.append( reuniaoDataCell(open: false, titulo:reunioesDados.dataReuniao , dadosSessao: [reunioesDados]))
                    //self.tableView.reloadData()
                    //self.table.reloadData()
                    
                     self.reunioesCorrente = self.reunioes
                    
                    //self.tableView.reloadData()
                    self.table.reloadData()
                })
            })
        }
    }
    
}
