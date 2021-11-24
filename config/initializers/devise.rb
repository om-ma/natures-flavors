Devise.secret_key = "1bc69ebc36d754f27509354977bf193378a850b4ef5d933e0f8a23e20188ba7b9f3ec19bff71029d906271c4670bd1137da6"

Devise.setup do |config|
    config.password_length = 7..128
end