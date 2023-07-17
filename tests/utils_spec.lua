local u = require("make-like-a-code.utils")

describe("split string", function()
    it("single newlines", function()
        local expected = { "foo", "bar", "baz" }
        local lines = u.split_string("foo\nbar\nbaz")
        assert.are.same(expected, lines)
    end) 

    it("newlines at start and end of string", function()
        local expected = { "", "foo", "bar", "baz", "" }
        local lines = u.split_string("\nfoo\nbar\nbaz\n")
        assert.are.same(expected, lines)
    end) 

    it("two adjacent newlines", function()
        local expected = { "foo", "", "bar", "baz" }
        local lines = u.split_string("foo\n\nbar\nbaz")
        assert.are.same(expected, lines)
    end) 
end)

describe("join strings", function()
    it("single newlines", function()
        local expected = "foo\nbar\nbaz"
        local lines = u.join_strings({ "foo", "bar", "baz" })
        assert.are.same(expected, lines)
    end) 

    it("newlines at start and end of string", function()
        local expected = "\nfoo\nbar\nbaz\n"
        local lines = u.join_strings({ "", "foo", "bar", "baz", "" })
        assert.are.same(expected, lines)
    end) 

    it("two adjacent newlines", function()
        local expected = "foo\n\nbar\nbaz"
        local lines = u.join_strings({ "foo", "", "bar", "baz" })
        assert.are.same(expected, lines)
    end) 
end)
