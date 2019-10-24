//
//  AddFotoViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 18/09/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage



class AddFotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var foto: UIImageView!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var btnSeleFoto: UIButton!
    @IBOutlet weak var btnAddFoto: UIButton!
    @IBOutlet weak var lblCarregando: UILabel!
    var idImagem = NSUUID().uuidString
    
    @IBOutlet weak var lblUrlImagem: UILabel!
    @IBOutlet weak var lblidImagem: UILabel!
    var index : Int = 0
    
    var participantes : [Participante] = []
    
    var urlImgFoto : String?
    var idImgFoto : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAddFoto.isEnabled = false
        imagePicker.delegate = self
        lblCarregando.text = ""
    }
    
    
    @IBAction func selecionar_foto(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[ UIImagePickerController.InfoKey.originalImage] as! UIImage
        foto.image = imagemRecuperada
        
        self.btnAddFoto.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func adicionar_foto(_ sender: Any) {
        self.btnAddFoto.isEnabled = false
        self.btnSeleFoto.isEnabled = false
        self.lblCarregando.text = "Carregando..."
        
        let armazenamento = Storage.storage().reference()
        let imagens = armazenamento.child("imagens")
        
        if let imagemSelecionada = foto.image {
            
            if let imagemDados =  imagemSelecionada.jpegData(compressionQuality: 0.5) {
                //UIImageJPEGRepresentation(imagemSelecionada,0.5) //UIImage.jpegData(imagemSelecionada)
                
                imagens.child("\(self.idImagem).jpg").putData(imagemDados, metadata: nil) { (metaDados, erro) in
                    if erro == nil {
                        print ("sucesso ao subir arquivo")
                        self.idImgFoto = "\(self.idImagem).jpg"
                        self.lblidImagem.text = "\(self.idImagem).jpg"
                        //let viewInc = IncluirParticipantes()
                        //viewInc.idImagem = "\(self.idImagem).jpg"
                        
                        //if self.index != -1 {
                           // self.participantes[self.index].idImagem =
                           // self.idImagem = "\(self.idImagem).jpg"
                       // }
                        
                        
                        imagens.child("\(self.idImagem).jpg").downloadURL(completion: { (url, erro) in
                            if let urlImagem = url?.absoluteString {
                                
                                self.urlImgFoto = urlImagem
                                self.lblUrlImagem.text = urlImagem
                                //viewInc.urlImagem = url?.absoluteString
                                self.performSegue(withIdentifier: "contSegue", sender: urlImagem)

                            }
                        })
                        
                        
                        self.btnAddFoto.isEnabled = true
                        self.btnSeleFoto.isEnabled = true
                        self.lblCarregando.text = ""
                        
                    }else {
                        print ("Erro ao subir arquivo")
                    }
                }
                
                
                
                
            }
            
            
        }
    }
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestinoView = segue.destination as! IncluirParticipantes
        if segue.identifier == "contSegue" {

            DestinoView.idImagem =  idImagem
            DestinoView.urlImagem = sender.self as! String
            //DestinoView.participantes = self.participantes
            //DestinoView.index = self.index
        }
    }
    
}
