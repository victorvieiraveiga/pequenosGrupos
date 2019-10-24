//
//  ExibeReunioesTableViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 27/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase


struct reuniaoDataCell {
    var open = Bool()
    var titulo = String()
    var dadosSessao = [ReuniaoItem]()
    //var dadosSessao = [String]()
}



class ExibeReunioesTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var idCelula : String = ""
    var tableViewData = [reuniaoDataCell]()
    var reunioes : [ReuniaoItem] = []
    var searchData : [ReuniaoItem]=[]

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        initialize ()
        alterLayout()
        setUpSearchBar()
        

    }
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableViewData[section].open == true {
            return tableViewData[section].dadosSessao.count //+ 1
        }else {
            return 1
        }
    }
    
    // cabeçalho do Tableview
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Data do Evento: " + tableViewData[section].titulo
        label.backgroundColor = UIColor.orange
        return label
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell: ReuniaoCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ReuniaoCell
                else {return UITableViewCell()}
            let reuniao = tableViewData[indexPath.section].dadosSessao[indexPath.row]
            
            cell.txtObs.text = reuniao.observacoes
            cell.txtParticipantes.text = reuniao.participantes 
            
            return cell
       }else {
            //se precisar usar celula com outro identificador
            guard let cell: ReuniaoCell = tableView.dequeueReusableCell(withIdentifier: "cellReuniao") as? ReuniaoCell else {return UITableViewCell()}

            let reuniao = tableViewData[indexPath.section].dadosSessao[indexPath.row-1]
            
            //cell.textLabel?.text = tableViewData[indexPath.section].dadosSessao[indexPath.row - 1] as? String
            cell.txtObs.text = reuniao.observacoes
            cell.txtParticipantes.text = reuniao.participantes

           
            return cell
        }
    }

    //remove registro
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let reuniao = self.tableViewData[indexPath.section].dadosSessao[indexPath.row]
            
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
                })
            }
        }
        self.initialize()
    }
    
    func alterLayout() {
        table.tableHeaderView = UIView()
        // search bar in section header
        table.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false // you can show/hide this dependant on your layout
        searchBar.placeholder = "Buscar por Data"
    }
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableViewData = tableViewData.filter({ reuniao -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return tableViewData[0].dadosSessao[0].dataReuniao.lowercased().contains(searchText.lowercased())
           // case 1:
           //     if searchText.isEmpty { return animal.category == .dog }
            //    return animal.name.lowercased().contains(searchText.lowercased()) &&
             //       animal.category == .dog
            //case 2:
             //   if searchText.isEmpty { return animal.category == .cat }
              //  return animal.name.lowercased().contains(searchText.lowercased()) &&
               //     animal.category == .cat
            default:
                return false
            }
        })
        table.reloadData()
    }
    
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        switch selectedScope {
//        case 0:
//            currentAnimalArray = animalArray
//        case 1:
//            currentAnimalArray = animalArray.filter({ animal -> Bool in
//                animal.category == AnimalType.dog
//            })
//        case 2:
//            currentAnimalArray = animalArray.filter({ animal -> Bool in
//                animal.category == AnimalType.cat
//            })
//        default:
//            break
//        }
//        table.reloadData()
//    }
    
}




//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            // delete item at indexPath
//
//
//            let reuniao = self.tableViewData[indexPath.section].dadosSessao[indexPath.row]
//
//            let database = Database.database().reference()
//            //pega id da celula do usuario logado
//            let autenticacao = Auth.auth()
//            //autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
//            if let usuarioLogado = autenticacao.currentUser?.uid {
//                //let usuarioLogado = usuario?.uid
//                let database = Database.database().reference()
//                let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuarioLogado)
//
//                celula.observe(DataEventType.childAdded, with: { (CelulaSnapshot) in
//                    //let dadosCel = CelulaSnapshot.value as! NSDictionary
//                    let reuniaoDados = database.child("reuniao").child(reuniao.idReuniao)
//                    let idReuniao = reuniaoDados.key
//                    let itemReuniao = reuniaoDados.child(idReuniao!)
//
//                    itemReuniao.child(idReuniao!).removeValue()
//
//
//                })
//            print("Delete at index : \(indexPath.row)")
//            }
//        }
//        delete.backgroundColor = UIColor(red: 210.0/255, green: 30.0/255, blue: 75.0/255, alpha: 1.0)
//
//        return [delete]
//        tableView.reloadData()
//    }

    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//
//                if tableViewData[indexPath.section].open == true {
//                    tableViewData[indexPath.section].open = false
//                    let sections = IndexSet.init(integer: indexPath.section)
//                    tableView.reloadSections(sections, with: .none)
//                }else {
//                    tableViewData[indexPath.section].open = true
//                    let sections = IndexSet.init(integer: indexPath.section)
//                    tableView.reloadSections(sections, with: .none)
//                }
 //      }

 //   }

extension ExibeReunioesTableViewController {
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
                print (self.idCelula)
                
                let reunioes = database.child("reuniao").queryOrdered(byChild: "idCelula").queryEqual(toValue: self.idCelula)//busca as reuniao da celula do usuario logado.
                
                reunioes.observe(DataEventType.childAdded, with: { (reuniaoSnapshot) in
                    // print (usuSnapshot)
                    
                    let dados = reuniaoSnapshot.value as! NSDictionary
                    
                    
                    let data = dados["dataReuniao"] as! String
                    let observacao = dados["observacao"] as! String
                    let participantes = dados["participantes"] as! String
                    let celulaNome = dados["celulaNome"] as! String
                    let idReuniao = reuniaoSnapshot.key
                    let idCelula = self.idCelula

                    let reunioesDados = ReuniaoItem(dataReuniao: data, participantes: participantes, observacoes: observacao, idCelula: idCelula, idReuniao: idReuniao, celulaNome: celulaNome)
                    
                    self.reunioes.append(reunioesDados)
                    
                    self.tableViewData.append( reuniaoDataCell(open: false, titulo:reunioesDados.dataReuniao , dadosSessao: [reunioesDados]))
                    self.tableView.reloadData()
                    
                })
            })
        }
    }
    
}


