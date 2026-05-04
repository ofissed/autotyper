import UIKit

class ViewController: UIViewController {
    
    private var typingTimer: Timer?
    private var currentIndex = 0
    private var textToType = ""
    private var isTyping = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Автотайпер"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let speedLabel: UILabel = {
        let label = UILabel()
        label.text = "Скорость (слов/мин):"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let speedTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "60"
        textField.text = "60"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Текст для ввода:"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let inputTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Привет! Это автоматический ввод текста."
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let outputLabel: UILabel = {
        let label = UILabel()
        label.text = "Результат:"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let outputTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .systemGray6
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Начать печать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Остановить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Очистить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(speedLabel)
        view.addSubview(speedTextField)
        view.addSubview(textLabel)
        view.addSubview(inputTextView)
        view.addSubview(outputLabel)
        view.addSubview(outputTextView)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            speedLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            speedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            speedTextField.centerYAnchor.constraint(equalTo: speedLabel.centerYAnchor),
            speedTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            speedTextField.widthAnchor.constraint(equalToConstant: 100),
            speedTextField.heightAnchor.constraint(equalToConstant: 40),
            
            textLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            inputTextView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8),
            inputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            inputTextView.heightAnchor.constraint(equalToConstant: 100),
            
            outputLabel.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 20),
            outputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            outputTextView.topAnchor.constraint(equalTo: outputLabel.bottomAnchor, constant: 8),
            outputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            outputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            outputTextView.heightAnchor.constraint(equalToConstant: 120),
            
            startButton.topAnchor.constraint(equalTo: outputTextView.bottomAnchor, constant: 20),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            
            stopButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 12),
            stopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stopButton.heightAnchor.constraint(equalToConstant: 50),
            
            clearButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 12),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startTyping), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopTyping), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearOutput), for: .touchUpInside)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func startTyping() {
        guard let speedText = speedTextField.text,
              let wpm = Int(speedText),
              wpm > 0 else {
            showAlert(title: "Ошибка", message: "Введите корректную скорость")
            return
        }
        
        textToType = inputTextView.text ?? ""
        guard !textToType.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите текст для печати")
            return
        }
        
        currentIndex = 0
        outputTextView.text = ""
        isTyping = true
        
        startButton.isEnabled = false
        startButton.alpha = 0.5
        stopButton.isEnabled = true
        stopButton.alpha = 1.0
        inputTextView.isEditable = false
        speedTextField.isEnabled = false
        
        let avgWordLength = 5.0
        let charactersPerMinute = Double(wpm) * avgWordLength
        let charactersPerSecond = charactersPerMinute / 60.0
        let intervalPerCharacter = 1.0 / charactersPerSecond
        
        typingTimer = Timer.scheduledTimer(withTimeInterval: intervalPerCharacter, repeats: true) { [weak self] _ in
            self?.typeNextCharacter()
        }
    }
    
    @objc private func stopTyping() {
        typingTimer?.invalidate()
        typingTimer = nil
        isTyping = false
        
        startButton.isEnabled = true
        startButton.alpha = 1.0
        stopButton.isEnabled = false
        stopButton.alpha = 0.5
        inputTextView.isEditable = true
        speedTextField.isEnabled = true
    }
    
    @objc private func clearOutput() {
        outputTextView.text = ""
        currentIndex = 0
    }
    
    private func typeNextCharacter() {
        guard currentIndex < textToType.count else {
            stopTyping()
            showAlert(title: "Готово!", message: "Текст полностью напечатан")
            return
        }
        
        let index = textToType.index(textToType.startIndex, offsetBy: currentIndex)
        let character = textToType[index]
        outputTextView.text.append(character)
        
        let range = NSRange(location: outputTextView.text.count - 1, length: 1)
        outputTextView.scrollRangeToVisible(range)
        
        currentIndex += 1
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
