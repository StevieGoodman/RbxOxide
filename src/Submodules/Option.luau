--!strict

--[=[
    @class Option
    An alternative to the Luau optionals, the `Option` class prevents you from forgetting that an optional
    value may be `nil`.
]=]--
local Option = {}

--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--

Option.__index = Option

--[=[
    @within Option
    @private
    @param value T -- Value used to create an `Option` object from
    @return Option -- `Option` object

    Used internally to store to create an `Option` object
]=]--
function Option._new(value)
    local self = setmetatable(
        {
            _v = value,
            _s = value ~= nil,
        },
        Option
    )
    return self
end

--[=[
    @within Option
    @prop None Option<None>
]=]--
Option.None = Option._new()

--[=[
    @within Option
    @function Some
    @param value Non-`nil` value to wrap as an `Option<Some>`
    @return Option<Some>
    
    Creates a `Option` object from a non-`nil` value.

    @error "Value is nil" -- Cannot create `Option<Some>` from a `nil` value
]=]--
function Option.Some(value)
    assert(value ~= nil, "Value is nil")
    return Option._new(value)
end

--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--

return Option