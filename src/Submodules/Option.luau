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
    @param value T -- Value used to create an `Option` object from
    @return Option -- `Option` object

    Creates an `Option` object from a value.
]=]--
function Option.new(value: any)
    local optionObject = { _value = value }
    local self = setmetatable(optionObject, Option)
    return self
end

--[=[
    @within Option
    @prop None Option<None>
]=]--
Option.None = Option.new()

--[=[
    @within Option
    @param value T -- Non-nil value to wrap as an Option<Some>
    @return Option<Some>

    Creates a `Option` object from a non-`nil` value.

    @error "Provided nil type" -- Cannot create `Option<Some>` from a `nil` value
]=]--
function Option.Some(value: any)
    assert(value ~= nil, "Provided nil type")
    return Option.new(value)
end

--[=[
    @within Option
    @return boolean

    Returns `true` if the object is of type `None`.
]=]--
function Option:IsNone(): boolean
    return self == Option.None
end

--[=[
    @within Option
    @return boolean

    Returns `true` if the object is of type `Some<T>`
]=]--
function Option:IsSome(): boolean
    return not self:IsNone()
end

--[=[
    @within Option
    @param cases { Some: (T)->(any), None: ()->(any) }
    @return any

    Executes code according to an exhaustive set of potential `Option` variants.
    Using this in strict mode prevents users from not accounting for a `None` variant.
    You may return a value if you would like.

    ```lua
    local someValue = Option.new(7878)
    local noneValue = Option.None

    local cases = {
        Some = function(value) return value end,
        None = function() return "Empty!" end
    }

    print(someValue:Match(cases)) -- 7878
    print(noneValue:Match(cases)) -- "Empty!"
    ```
]=]--
function Option:Match(cases: { Some: (any)->(any), None: ()->(any) }): any
    if self:IsSome() then
        return cases.Some(self._value)
    elseif self:IsNone() then
        return cases.None()
    end
end

--[=[
    @within Option
    @return any

    Unsafely unwraps the value inside the `Option`.  
    Good for debugging and testing. Do not use in production, instead use `:Match()` or `:UnwrapOr()`.

    @error ":Unwrap() may not be called on Option.None objects"
]=]--
function Option:Unwrap(): any
    warn(":Unwrap() should only be used for debugging purposes. For production, instead use :Match()")
    assert(self:IsSome(), ":Unwrap() may not be called on Option.None objects")
    return self._value
end

--[=[
    @within Option
    @param default any -- Returned if `Option:IsNone()`
    @return any

    Safely unwraps the `Option` by returning `default` if `Option:IsNone()`.

    ```lua
    local someValue = Option.new(7878)
    local noneValue = Option.None

    print(someValue:UnwrapOr("Oh no!")) -- 7878
    print(noneValue:UnwrapOr("...anyway!")) -- "...anyway!"
    ```
]=]--
function Option:UnwrapOr(default: any): any
    return self:Match {
        Some = function(value) return value end,
        None = function() return default end
    }
end

--[=[
    @within Option
    @param defaultFn any -- Returned if `Option:IsNone()`
    @return any

    Safely unwraps the `Option` by returning the result of `defaultFn` if `Option:IsNone()`.

    ```lua
    local someValue = Option.new(7878)
    local noneValue = Option.None

    print(someValue:UnwrapOrElse(function() return "Oh no!" end)) -- 7878
    print(noneValue:UnwrapOrElse(function() return "...anyway!" end)) -- "...anyway!"
    ```
]=]--
function Option:UnwrapOrElse(defaultFn: ()->(any)): any
    return self:Match {
        Some = function(value) return value end,
        None = function() return defaultFn() end
    }
end

--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--x--

return Option