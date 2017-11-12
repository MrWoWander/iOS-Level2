import UIKit

class Auth: UIViewController {
    
    @IBOutlet weak var scrollAuth: UIScrollView! //Скролл
    @IBOutlet weak var loginText: UITextField! //Поле с логином
    @IBOutlet weak var passwordText: UITextField! //Поле с паролем

    override func viewDidLoad() {
        super.viewDidLoad()
        //вызов функции закрытия клавиатуры при нажатии на пустую область
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        scrollAuth?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Вызов клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //удаление из памяти вызова клавиатуры
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //Алерт с ошибками
    func errorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Кнопка авторизации
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let login = loginText.text!
        let password = passwordText.text!
        
        if login == "admin" && password == "admin" {
            return true
        } else {
            errorAlert(title: "Error", message: "Введен неправильный логин/пароль")
            return false
        }
    }
    
    // Получаем размер клавиатуры
    @objc func keyboardWasShow(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsent = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        
        //Срабатывания скролла
        self.scrollAuth?.contentInset = contentInsent
        scrollAuth?.scrollIndicatorInsets = contentInsent
    }
    
    //Возвращение скролла на место
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsert = UIEdgeInsets.zero
        scrollAuth?.contentInset = contentInsert
        scrollAuth?.scrollIndicatorInsets = contentInsert
    }
    
    //закрытие клавиатуры при нажантии на пустую область
    @objc func hideKeyboard() {
        self.scrollAuth?.endEditing(true)
    }
}
