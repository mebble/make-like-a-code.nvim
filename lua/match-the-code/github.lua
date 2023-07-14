local curl = require('plenary.curl')
print(vim.inspect(curl.get("https://api.chucknorris.io/jokes/random")))
