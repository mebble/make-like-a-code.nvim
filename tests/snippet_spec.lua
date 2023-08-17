local s = require('make-like-a-code.snippet')

local contents = [[
ext
--mlac--
content1
content1
--mlac--
content2
content2
]]

describe("parse contents", function()
    it("parses and trims newlines", function()
        local ext, raw, parent = s.parse_contents(contents)
        assert.equals("ext", ext)
        assert.equals("content1\ncontent1", raw)
        assert.equals("content2\ncontent2", parent)
    end)
end)

describe("extension to language", function()
    local languages = {
        LANG1 = {
            extensions = { ".lang1", ".test.lang1" },
        },
        LANG2 = {},
    }

    it("language not found", function()
        local lang = s.extension_to_language(languages, "foo")
        assert.equals(nil, lang)
    end)

    it("language doesn't have extensions", function()
        local lang = s.extension_to_language(languages, "foo")
        assert.equals(nil, lang)
    end)

    it("language found, made lowercase", function()
        local lang = s.extension_to_language(languages, "lang1")
        assert.equals("lang1", lang)
    end)
end)
